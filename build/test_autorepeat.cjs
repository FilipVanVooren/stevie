/* Execute the built cartridge's scheduler, console KSCAN, bank-switch
 * trampoline, repeat engine, and key dispatcher in Old-Js99er's TMS9900.
 * Screen/file action bodies are intercepted after dispatch. Character
 * handlers run their real validation/arming code and unwind their stacks.
 * This verifies keyboard behavior, not the editor's drawing/file routines.
 * Usage: node build/test_autorepeat.cjs [VDP mode, default 3080]
 */
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const assert = require('node:assert/strict');
const root = path.resolve(__dirname, '..');
const emu = path.resolve(root, '../test-emulator/src');
const mode = process.argv[2] || '3080';
const out = path.join(__dirname, 'autorepeat', mode);
const sandbox = vm.createContext({
    console,
    Log: {getLog: () => ({info() {}, warn() {}, error(s) {throw Error(s);}})},
    DiskDrive: {DSR_ROM: []},
});
for (const file of ['util.js', 'software/system.js', 'emu/decoder.js',
    'emu/tms9900.js', 'emu/ams.js', 'emu/memory.js', 'emu/cru.js', 'emu/keyboard.js']) {
    vm.runInContext(fs.readFileSync(path.join(emu, file), 'utf8'), sandbox, {filename: file});
}
function symbols(bank) {
    return Object.fromEntries([...fs.readFileSync(path.join(out, `stevie_b${bank}.equ`), 'utf8')
        .matchAll(/([^\s:]+):\s+equ\s+>([\da-f]+)/gi)]
        .map(m => [m[1].toLowerCase(), parseInt(m[2], 16)]));
}
const s = symbols('1');
const zero = symbols('0');
const colors = symbols('4');
const roms = [...'0123456789abcdef'].map(b => fs.readFileSync(path.join(out, `stevie_b${b}.bin`)));
const keymapTargets = new Set();
for (const label of ['keymap_actions.editor', 'keymap_actions.cmdb']) {
    for (let a = s[label] - 0x6000; roms[1][a] !== 0xff; a += 4) {
        keymapTargets.add(roms[1].readUInt16BE(a + 2));
    }
}
keymapTargets.add(s['edk.act.block.mark']);
keymapTargets.add(s['edkey.key.process.flash']);
const labels = Object.fromEntries(Object.entries(s).map(([name, addr]) => [addr, name]));
function machine(pal = false, options = {}) {
    const keyboard = {
        columns: Array.from({length: 8}, () => Array(11).fill(false)),
        isKeyDown(col, row) {return this.columns[col][row];},
        isAlphaLockDown() {return false;},
    };
    const vdp = {status: 0, ram: new Uint8Array(0x4000), address: 0, latch: null, prefetch: 0,
        readStatus() {const v = this.status; this.status = 0; return v;},
        readData() {const v = this.prefetch; this.prefetch = this.ram[this.address++ & 0x3fff]; return v;},
        writeData(v) {this.ram[this.address++ & 0x3fff] = v;},
        writeAddress(v) {
            if (this.latch === null) {this.latch = v; return;}
            if (!(v & 0x80)) {
                this.address = (v & 0x3f) << 8 | this.latch;
                if (!(v & 0x40)) this.prefetch = this.ram[this.address++ & 0x3fff];
            }
            this.latch = null;
        }};
    const memory = new sandbox.Memory(vdp, {writeData() {}}, {}, {
        is32KRAMEnabled: () => true, isAMSEnabled: () => true,
        isGRAMEnabled: () => false, isGoogleDriveEnabled: () => false,
    });
    // Match Stevie's startup SAMS map so banked drawing helpers can
    // activate dialog pages without losing the resident library.
    for (const [region, page] of [[2, 0], [3, 1], [10, 4], [11, 0x20],
        [12, 0x40], [13, 5], [14, 6], [15, 7]]) memory.ams.registerMap[region] = page;
    memory.ams.setMode(sandbox.AMS.MAPPING_MODE);
    memory.setCartridgeImage(Buffer.concat(roms), false, false, false, false);
    const cru = new sandbox.CRU(keyboard, {});
    cru.setMemory(memory);
    const cpu = new sandbox.TMS9900(memory, cru, keyboard, [], []);
    cru.setTMS9900(cpu);
    cpu.WP = 0x8300;
    const read = addr => cpu.readMemoryWord(addr);
    const write = (addr, value) => cpu.writeMemoryWord(addr, value);
    const get = name => read(s[name]);
    const set = (name, value) => write(s[name], value);
    memory.loadRAM(0x2000, roms[0].subarray(zero['reloc.resident'] - 0x6000));
    // LOADMC normally installs this copy/fill loop during library startup.
    for (let n = 0; n < 6; n += 2) write(s.mcloop + 2 + n, read(s.mccode + n));
    write(0x6002, 0); // Bank 1, matching normal scheduler operation.
    write(0x8304, 0x0140 | (pal ? 0x2000 : 0)); // Enabled kernel + user hook.
    write(0x8312, s['sp2.stktop']);
    set('wtitab', s.timers);
    set('wtiusr', s['edkey.keyscan.hook']);
    set('tv.fj.stackpnt', 0xaffc);
    set('tv.sams.b000', 0x20);
    set('tv.sams.c000', 0x40);
    cpu.writeMemoryByte(0x8373, 0x80);
    cpu.PC = s.tmgr;
    const events = [];
    let frames = 0;
    let hooks = 0;
    function step() {
        if (options.realColors && memory.currentCartBank === 4) {
            // Run the real color command and its banked return path.
            // Bypass its redraw helpers; test the actual key-color painter separately.
            if (cpu.PC === colors['pane.colorscheme.load']) {
                cpu.PC = read(0x8316); return;
            }
            if (cpu.PC === s.putnum || cpu.PC === s.putat) {
                cpu.PC = read(0x8316) + (cpu.PC === s.putnum ? 8 : 4); return;
            }
        }
        if (memory.currentCartBank === 1) {
            if (cpu.PC === s['edkey.keyscan.hook']) hooks++;
            if (keymapTargets.has(cpu.PC)) {
                events.push({frame: frames, key: get('keycode1'), action: labels[cpu.PC], address: cpu.PC});
                const runBody = (options.realColors && cpu.PC === s['pane.colorscheme.cycle']) ||
                    (options.realAutoUnpack && cpu.PC === s['edk.act.cmdb.am.toggle']);
                if (!runBody) {
                    // Returning command bodies must exercise the hook's R11
                    // contract, instead of bypassing it with a jump to HOOKOK.
                    cpu.PC = options.returningActions ? read(0x8316) : s.hookok;
                    return;
                }
            }
            // Stop screen work after the real character handler has armed
            // repeat; execute its actual exit so stack restoration is tested.
            const pc = cpu.PC;
            if (get('kb.repeat.allow') &&
                pc >= s['edk.fb.char'] && pc < s['edk.fb.char.exit']) {
                events.push({frame: frames, key: get('keycode1'), action: 'character'});
                cpu.PC = s['edk.fb.char.exit'];
            } else if (get('kb.repeat.allow') &&
                pc >= s['edk.act.cmdb.char'] && pc < s['edk.act.cmdb.char.exit']) {
                events.push({frame: frames, key: get('keycode1'), action: 'command character'});
                cpu.PC = s['edk.act.cmdb.char.exit'];
            }
        }
        if (cpu.PC === s['cpu.crash']) throw Error(`CPU crash, frame ${frames}`);
        const instruction = cpu.readMemoryWord(cpu.PC);
        cpu.inctPC();
        cpu.addCycles(cpu.execute(instruction));
        assert.equal(cpu.illegalCount, 0, `Illegal instruction at ${cpu.PC.toString(16)}`);
    }
    function frame() {
        frames++;
        vdp.status = 0x80;
        const before = hooks;
        for (let n = 0; n < 20000; n++) {
            step();
            if (hooks > before && cpu.PC === s.tmgr1) {
                assert.equal(memory.currentCartBank, 1, 'Trampoline must restore bank 1');
                assert.equal(read(0x8312), s['sp2.stktop'], 'Value stack must balance');
                assert.equal(get('tv.fj.stackpnt'), 0xaffc, 'Far-jump stack must balance');
                return;
            }
        }
        throw Error(`Frame did not return: PC=${cpu.PC.toString(16)}, bank=${memory.currentCartBank}, ` +
            `palette=${get('tv.colorscheme')}, dispatched=${events.length}`);
    }
    return {cpu, memory, vdp, events, get, set, frame,
        invoke(bank, addr) {
            const caller = {bank: memory.currentCartBank, pc: cpu.PC, r11: read(0x8316),
                stack: read(0x8312), farStack: get('tv.fj.stackpnt')};
            write(0x6000 + bank * 2, 0);
            write(0x8316, 0x5f00);
            cpu.PC = addr;
            const trace = [];
            for (let n = 0; n < 100000; n++) {
                trace.push(`${memory.currentCartBank}:${cpu.PC.toString(16)}:${cpu.readMemoryWord(cpu.PC).toString(16)}`);
                if (trace.length > 25) trace.shift();
                try {step();} catch (error) {throw Error(trace.join(' ') + '\n' + error.message);}
                if (cpu.PC === 0x5f00) {
                    assert.equal(read(0x8312), caller.stack, 'Subroutine value stack must balance');
                    assert.equal(get('tv.fj.stackpnt'), caller.farStack, 'Subroutine far-jump stack must balance');
                    write(0x6000 + caller.bank * 2, 0);
                    write(0x8316, caller.r11);
                    cpu.PC = caller.pc;
                    return;
                }
            }
            throw Error(`Subroutine did not return: ${cpu.PC.toString(16)}`);
        },
        frames: n => {for (let i = 0; i < n; i++) frame();},
        press(...codes) {
            keyboard.columns.forEach(column => column.fill(false));
            for (const keyCode of codes) sandbox.Keyboard.prototype.keyEvent.call(keyboard,
                {keyCode, preventDefault() {}}, true);
        },
        idle() {const count = hooks; for (let n = 0; n < 10000; n++) step();
            assert.equal(hooks, count, 'Hook must not run again in the same VDP frame');},
    };
}
let passed = 0;
function test(name, run) {run(); passed++; console.log(`PASS ${name}`);}
for (const pal of [false, true]) {
    const hz = pal ? 50 : 60;
    const delay = pal ? 25 : 30;
    const rate = pal ? 4 : 5;
    test(`${hz} Hz: immediate type, 500 ms delay, repeat interval, idle pacing, release`, () => {
        const m = machine(pal);
        m.press(65); m.frame();
        assert.equal(m.events.length, 1);
        assert.equal(m.events[0].key, 97); // Lowercase with alpha-lock off.
        m.idle();
        m.frames(delay - 1); assert.equal(m.events.length, 1);
        m.frame(); assert.equal(m.events.length, 2);
        m.frames(rate - 1); assert.equal(m.events.length, 2);
        m.frame(); assert.equal(m.events.length, 3);
        m.press(); m.frame(); m.frames(2 * delay);
        assert.equal(m.events.length, 3);
        assert.equal(m.get('kb.repeat.allow'), 0);
    });
    test(`${hz} Hz: new key and quick same-key re-press restart long delay`, () => {
        const m = machine(pal);
        m.press(65); m.frames(10);
        m.press(66); m.frame();
        assert.deepEqual(m.events.map(e => e.key), [97, 98]);
        m.frames(delay - 1); assert.equal(m.events.length, 2);
        m.press(); m.frame(); m.press(66); m.frame();
        assert.equal(m.events.length, 3);
        m.frames(delay - 1); assert.equal(m.events.length, 3);
        m.frame(); assert.equal(m.events.length, 4);
    });
}
for (const [key, label] of [[83, 'left'], [68, 'right'], [69, 'up'], [88, 'down'], [49, 'del_char']]) {
    test(`FCTN-${String.fromCharCode(key)} repeats ${label}`, () => {
        const m = machine(); m.press(18, key); m.frames(61);
        assert.equal(m.events.length, 8);
        assert(m.events.every(e => e.address === s[`edk.act.${label}`]), JSON.stringify(m.events));
    });
}
for (const [codes, description] of [[[13], 'ENTER'], [[18, 51], 'delete line'],
    [[18, 190], 'insert-mode toggle'], [[17, 83], 'save'], [[17, 81], 'quit'],
    [[17, 32], 'CTRL-space block marking']]) {
    test(`${description} stays single-press`, () => {
        const m = machine(); m.press(...codes); m.frames(100);
        assert.equal(m.events.length, 1);
        assert.equal(m.get('kb.repeat.allow'), 0);
    });
}
test('Holding a menu letter does not repeat its command', () => {
    const m = machine(); m.set('tv.pane.focus', 1); m.set('cmdb.dialog', s['id.dialog.main']);
    m.press(70); m.frames(100); assert.equal(m.events.length, 1);
});
test('Command input types repeatedly; catalog SPACE stays single-press', () => {
    const m = machine(); m.set('tv.pane.focus', 1); m.set('cmdb.dialog', s['id.dialog.open']);
    m.press(65); m.frames(61); assert.equal(m.events.length, 8);
    assert(m.events.every(e => e.action === 'command character'));
    m.press(); m.frame(); m.press(32); m.frames(100);
    assert.equal(m.events.length, 9);
});
for (const [key, label] of [[83, 'left'], [68, 'right'], [49, 'del_char'], [69, 'pick.prev'], [88, 'pick.next']]) {
    test(`Command/catalog FCTN-${String.fromCharCode(key)} repeats ${label}`, () => {
        const m = machine(); m.set('tv.pane.focus', 1); m.set('cmdb.dialog', s['id.dialog.open']);
        m.press(18, key); m.frames(61); assert.equal(m.events.length, 8);
        assert(m.events.every(e => e.address === s[`edk.act.cmdb.${label}`]), JSON.stringify(m.events));
    });
}
test('Changing pane or dialog cancels a held key until a fresh press', () => {
    const m = machine(); m.press(65); m.frame();
    m.set('tv.pane.focus', 1); m.set('cmdb.dialog', s['id.dialog.open']);
    m.frames(100); assert.equal(m.events.length, 1);
    m.set('tv.pane.focus', 0); m.frames(100); assert.equal(m.events.length, 1);
    m.press(); m.frame(); m.press(65); m.frame(); assert.equal(m.events.length, 2);
    m.set('cmdb.dialog', s['id.dialog.find']); m.frames(100);
    assert.equal(m.events.length, 2);
});
test('Adding CTRL to held SPACE does not repeat block marking', () => {
    const m = machine(); m.press(32); m.frames(40);
    const before = m.events.length;
    m.press(17, 32); m.frames(100);
    assert(m.events.length <= before + 1);
    assert.equal(m.get('kb.repeat.allow'), 0);
});
test('Shifted typing preserves case and repeats', () => {
    const m = machine(); m.press(16, 65); m.frames(61);
    assert.equal(m.events.length, 8); assert(m.events.every(e => e.key === 65));
});
test('Releasing FCTN while an arrow key is held cancels repeat', () => {
    const m = machine(); m.press(18, 83); m.frames(40);
    const before = m.events.length;
    m.press(83); m.frames(100);
    assert.equal(m.events.length, before);
    m.press(); m.frame(); m.press(83); m.frame();
    assert.equal(m.events.at(-1).key, 115);
});
test('Releasing SHIFT while a letter is held cancels repeat', () => {
    const m = machine(); m.press(16, 65); m.frames(40);
    const before = m.events.length;
    m.press(65); m.frames(100); assert.equal(m.events.length, before);
});
test('Locked editor does not arm repeat for typing', () => {
    const m = machine(); m.set('edb.locked', 0xffff);
    m.press(65); m.frames(100); assert.equal(m.events.length, 1);
    assert.equal(m.get('kb.repeat.allow'), 0);
});
test('Color command returns to scanning and runs once per press', () => {
    const m = machine(false, {realColors: true});
    m.set('tv.colorscheme', 1);
    m.press(17, 90); m.frame();
    assert.equal(m.get('tv.colorscheme'), 2);
    m.frames(100); assert.equal(m.get('tv.colorscheme'), 2);
    m.press(); m.frame(); m.press(17, 90); m.frame();
    assert.equal(m.get('tv.colorscheme'), 3);
    m.press(); m.frame(); m.press(65); m.frame();
    assert.equal(m.events.at(-1).key, 97, 'Typing remains responsive after changing colors');
});
test('Menu color command also returns once and permits another key', () => {
    const m = machine(false, {realColors: true});
    m.set('tv.pane.focus', 1); m.set('cmdb.dialog', s['id.dialog.shortcuts']);
    m.set('tv.colorscheme', 1); m.press(67); m.frame();
    m.frames(100); assert.equal(m.get('tv.colorscheme'), 2);
    m.press(); m.frame(); m.press(67); m.frame();
    assert.equal(m.get('tv.colorscheme'), 3);
});
test('Commands that return through R11 consume their key once', () => {
    const m = machine(false, {returningActions: true});
    m.press(17, 83); m.frames(100); assert.equal(m.events.length, 1);
});
const bottomLayouts = ['default', 'defaultb', 'defaultc', 'defaultd'];
const bottomColors = [0x17, 0xc1, 0x1a, 0xe1, 0x17, 0x1c, 0x1f, 0x12, 0xf1, 0x10, 0x16, 0x1f];
for (let scheme = 1; scheme <= bottomColors.length; scheme++) {
    test(`Scheme ${scheme}: F9-Menu and ^H-Help have matching colors in all editor bars`, () => {
        const m = machine();
        m.set('tv.colorscheme', scheme);
        for (const layout of bottomLayouts) {
            m.set('cmdb.keycolors', s[`col.keys.${layout}`]);
            m.invoke(4, colors['pane.botline.keycolor']);
            const tat = m.vdp.ram.subarray(colors['vdp.botrow.tat'], colors['vdp.botrow.tat'] + 80);
            for (let column = 0; column < 80; column++) {
                assert.equal(tat[column], bottomColors[scheme - 1], `${layout} column ${column}`);
            }
        }
    });
}
test('Editor bottom-bar shortcut descriptions include dashes without shifting fields', () => {
    const m = machine();
    const expected = [
        'F9-Menu  ^H-Help',
        'F9-Menu  ^H-Help  F0-Basic# ',
        'F9-Menu  ^H-Help  ^,-Prev  ^.-Next  ^4-Done',
        'F9-Menu  ^H-Help  F0-Basic#   ^,-Prev  ^.-Next  ^4-Done',
    ];
    for (const [i, layout] of bottomLayouts.entries()) {
        const address = s[`txt.keys.${layout}`];
        const length = m.memory.getByte(address);
        const text = String.fromCharCode(...Array.from({length}, (_, n) => m.memory.getByte(address + n + 1)));
        assert.equal(text, expected[i], layout);
    }
});
const basicSymbols = symbols('3');
for (let scheme = 1; scheme <= 12; scheme++) {
    test(`Scheme ${scheme}: AutoUnpack toggles and redraws repeatedly without corruption`, () => {
        const m = machine(false, {realAutoUnpack: true});
        m.invoke(1, s['rom.dialogs2ram']);
        m.set('tv.colorscheme', scheme);
        m.set('tv.pane.focus', 1);
        m.set('cmdb.dialog', s['id.dialog.basic']);
        const paletteOffset = colors['tv.colorscheme.table'] - 0x6000 + (scheme - 1) * 10 + 8;
        const normal = roms[4][paletteOffset];
        const marker = roms[4][paletteOffset + 1];
        for (let press = 1; press <= 4; press++) {
            const enabled = press % 2 === 1;
            const suffix = enabled ? 'basic2' : 'basic';
            m.press(18, 53); m.frame(); // FCTN-5 through the real key dispatcher.
            assert.equal(m.get('tib.autounpk'), enabled ? 0xffff : 0);
            assert.equal(m.get('cmdb.pankeys'), basicSymbols[`txt.keys.${suffix}`]);
            assert.equal(m.get('cmdb.keycolors'), basicSymbols[`col.keys.${suffix}`],
                'The color pointer must reference a marker list, not the label text');
            m.memory.loadRAM(s.rambuf + 80, Buffer.alloc(16, 0xa5));
            m.invoke(4, colors['pane.botline.keycolor']);
            const expected = Array(80).fill(normal);
            const columns = enabled ? [0, 1, 2] : [0, 1, 9, 10, 24, 25, 26, 27, 28];
            for (const column of columns) expected[column] = marker;
            assert.deepEqual([...m.vdp.ram.subarray(colors['vdp.botrow.tat'], colors['vdp.botrow.tat'] + 80)],
                expected, 'Only the intended shortcut positions may be highlighted');
            for (let i = 0; i < 16; i++) assert.equal(m.memory.getByte(s.rambuf + 80 + i), 0xa5,
                'Redrawing must not write outside the 80-byte color buffer');
            m.frames(40); // Holding FCTN-5 must not toggle again.
            assert.equal(m.get('tib.autounpk'), enabled ? 0xffff : 0);
            m.press(); m.frame();
        }
        m.set('tv.pane.focus', 0); m.set('cmdb.dialog', 0);
        m.press(65); m.frame();
        assert.equal(m.events.at(-1).action, 'character', 'Keyboard scanning remains responsive');
    });
}
console.log(`${passed} keyboard machine-code tests passed for VDP mode ${mode}.`);

// Full native BASIC/editor execution regression tests using Old-Js99er.
// Run from any directory: node build/test_basic_sessions.cjs --mixed --empty-basic --quiet
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const root = path.resolve(__dirname, '..');
const emu = path.resolve(root, '../test-emulator/src');
const mode = Number(process.argv.find(a => a.startsWith('--mode='))?.split('=')[1] || 6080);
const out = path.join(__dirname, 'autorepeat', String(mode));
const verify = true;
const sandbox = vm.createContext({console, performance, window: {performance},
    Image: class {}, DiskDrive: {DSR_ROM: []},
    F18AFlash: class {reset() {}},
    Log: {LEVEL_NONE: 0, LEVEL_INFO: 1, getLog: () => ({setMinLevel() {}, info() {}, debug() {}, warn(s) {console.error(s);}, error(s) {throw Error(s);}})},
});
for (const file of ['util.js', 'software/system.js', 'emu/decoder.js',
    'emu/tms9900.js', 'emu/ams.js', 'emu/memory.js', 'emu/cru.js', 'emu/keyboard.js', 'emu/f18agpu.js', 'emu/f18a.js']) {
    vm.runInContext(fs.readFileSync(path.join(emu, file), 'utf8'), sandbox, {filename: file});
}
const keys = {columns: Array.from({length: 8}, () => Array(11).fill(false)),
    isKeyDown(col, row) {return this.columns[col][row];}, isAlphaLockDown() {return true;},
    getPasteCharCode() {return -1;}};
const tape = {setMotorOn() {}, setAudioGate() {}, write() {}, read() {return false;}};
const cru = new sandbox.CRU(keys, tape);
const canvas = {width: 0, height: 0, getContext() {return {
    fillRect() {}, putImageData() {}, drawImage() {},
    getImageData(x, y, w, h) {return {data: new Uint8ClampedArray(w * h * 4)};},
};}};
const sound = {writeData() {}, setGROMClock() {}};
const vdp = new sandbox.F18A(canvas, cru, sound, false);
// Give newly started GPU code a time slice before the CPU can stop it;
// Stevie's eight-byte hardware probe depends on that concurrent execution.
const writeVDPRegister = vdp.writeRegister;
vdp.writeRegister = function (reg, value) {
    writeVDPRegister.call(this, reg, value);
    if (reg === 55 && this.gpu.getPC() && !this.gpu.isIdle()) this.gpu.run(1000);
};
const memory = new sandbox.Memory(vdp, sound, {}, {
    is32KRAMEnabled: () => true, isAMSEnabled: () => true,
    isGRAMEnabled: () => false, isGoogleDriveEnabled: () => false,
});
const image = process.argv.slice(2).find(a => !a.startsWith('--')) ||
    path.join(__dirname, 'autorepeat', `stevie${Math.floor(mode / 100)}_8.bin`);
const imageData = fs.readFileSync(image);
memory.setCartridgeImage(imageData, false, false, false, false);
cru.setMemory(memory);
const cpu = new sandbox.TMS9900(memory, cru, keys, [], []);
cru.setTMS9900(cpu);
cru.writeBit(2, true); // Console startup normally unmasks the VDP interrupt.
cpu.reset();
cpu.PC = imageData.readUInt16BE(0x0e);
cpu.WP = 0x8300;
function symbols(bank) {
    return Object.fromEntries([...fs.readFileSync(path.join(out, `stevie_b${bank}.equ`), 'utf8')
        .matchAll(/([^\s:]+):\s+equ\s+>([\da-f]+)/gi)]
        .map(m => [m[1].toLowerCase(), parseInt(m[2], 16)]));
}
const s = symbols('1');
let count = 0;
function run(frames) {
    for (let f = 0; f < frames; f++) {
        vdp.statusRegister |= 0x80;
        cru.setVDPInterrupt(!!vdp.interruptsOn);
        for (let slice = 0; slice < 50; slice++) {
            cpu.run(1000);
            if (!vdp.gpu.isIdle()) vdp.gpu.run(25000);
        }
        cru.decrementTimer(781);
        count++;
    }
}
function press(...codes) {
    keys.columns.forEach(c => c.fill(false));
    for (const keyCode of codes) sandbox.Keyboard.prototype.keyEvent.call(keys,
        {keyCode, preventDefault() {}}, true);
    run(8);
    keys.columns.forEach(c => c.fill(false));
    run(8);
}
function state(label) {
    if (process.argv.includes('--quiet')) return;
    const names = ['tv.pane.focus', 'cmdb.dialog', 'cmdb.visible', 'edb.locked',
        'fb.column', 'fb.current', 'fb.row.length', 'edb.insmode', 'tib.session',
        'tib.autounpk', 'kb.repeat.allow', 'tv.sams.c000', 'cmdb.keycolors',
        'fb.scrrows', 'fb.row', 'wyx', 'fb.curtoggle'];
    const vars = Object.fromEntries(names.map(n => [n, memory.getWord(s[n])]));
    const text = String.fromCharCode(...vdp.ram.subarray(0, 160)).replace(/[^\x20-\x7e]/g, '.');
    const basic = String.fromCharCode(...vdp.ram.subarray(0, 768).map(b => b >= 0x80 ? b - 0x60 : b)).replace(/[^\x20-\x7e]/g, '.');
    console.log(JSON.stringify({label, frame: count, pc: cpu.PC.toString(16), wp: cpu.WP.toString(16),
        bank: memory.currentCartBank, status: cpu.ST.toString(16), illegal: cpu.illegalCount,
        interrupt: [vdp.interruptsOn, cru.cru[2], memory.getWord(0x83c4).toString(16)],
        mapping: memory.ams.registerMap, vars, text, basic}, null, 2));
}
function checkEditor(label) {
    const get = n => memory.getWord(s[n]);
    for (const n of ['tv.pane.focus', 'cmdb.dialog', 'cmdb.visible', 'edb.locked']) {
        if (get(n) !== 0) throw Error(`${label}: ${n}=${get(n)}`);
    }
    if (memory.currentCartBank !== 1) throw Error(label + ': incorrect ROM bank');
    const expected = (get('fb.row') << 8) | get('fb.column');
    if (get('wyx') !== expected) throw Error(`${label}: cursor=${get('wyx')}, expected=${expected}`);
    const toggles = new Set();
    for (let n = 0; n < 40; n++) {run(1); toggles.add(get('fb.curtoggle'));}
    if (toggles.size !== 2) throw Error(label + ': cursor blink has stopped');
}
run(180);
state('boot');
if (!process.argv.includes('--empty-editor')) {press(65); state('typed a');}
const passes = Number(process.argv.find(a => a.startsWith('--passes='))?.split('=')[1] || 6);
for (let pass = 1; pass <= passes; pass++) {
    const direct = pass > 1 && (process.argv.includes('--resume') ||
        (process.argv.includes('--mixed') && pass % 2 === 0));
    if (direct) press(18, 48);
    else {
        press(18, 57); press(66);
        if (pass === 1 && process.argv.includes('--auto')) press(18, 53);
        press(process.argv.includes('--cycle') ? 49 + (pass - 1) % 3 : 49);
    }
    run(100);
    state('entered ' + pass);
    if (pass === 1 && !process.argv.includes('--empty-basic')) {
        for (const c of '10 A=1') press(c === '=' ? 187 : c.charCodeAt(0));
        press(13); run(40);
        state('entered BASIC program');
    }
    if (process.argv.includes('--hotkey')) press(18, 57);
    else {press(69); press(78); press(68); press(13);}
    run(Number(process.argv.find(a => a.startsWith('--wait='))?.split('=')[1] || 200));
    state('returned ' + pass);
    if (!verify || (!direct && !process.argv.includes('--auto'))) {
        if (process.argv.includes('--dismiss')) {press(18, 57); press(18, 57);}
        else press(32);
        run(40);
    }
    state('manual unpack ' + pass);
    if (verify) checkEditor('return ' + pass);
    const before = memory.getWord(s['fb.column']);
    press(65);
    state('typed after unpack ' + pass);
    if (verify) {
        if (memory.getWord(s['fb.column']) !== before + 1) throw Error('Typing failed at pass ' + pass);
        press(18, 83);
        if (memory.getWord(s['fb.column']) !== before) throw Error('Left arrow failed at pass ' + pass);
        press(18, 68);
        if (memory.getWord(s['fb.column']) !== before + 1) throw Error('Right arrow failed at pass ' + pass);
        checkEditor('typing and movement ' + pass);
        press(13); press(65); // Leave the cursor off the first row for the next return.
    }
}
if (verify) console.log(JSON.stringify({passed: true, mode, passes, image}));

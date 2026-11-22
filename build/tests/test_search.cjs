// Native file loading and find-dialog regression tests using Old-Js99er.
// Usage: node build/test_search.cjs --mode=6080 [--file=PATH]
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');
const root = path.resolve(__dirname, '..');
const emu = path.resolve(root, '../test-emulator/src');
const mode = Number(process.argv.find(a => a.startsWith('--mode='))?.split('=')[1] || 6080);
const out = path.join(__dirname, 'autorepeat', String(mode));
const assert = require('node:assert/strict');
const sandbox = vm.createContext({console, performance, window: {performance},
    Image: class {}, DiskDrive: {DSR_ROM: []},
    F18AFlash: class {reset() {}},
    Log: {LEVEL_NONE: 0, LEVEL_INFO: 1, getLog: () => ({setMinLevel() {}, info() {}, debug() {}, warn(s) {console.error(s);}, error(s) {throw Error(s);}})},
});
for (const file of ['util.js', 'software/system.js', 'emu/decoder.js',
    'emu/disk.js', 'emu/tms9900.js', 'emu/ams.js', 'emu/memory.js', 'emu/cru.js', 'emu/keyboard.js', 'emu/f18agpu.js', 'emu/f18a.js']) {
    vm.runInContext(fs.readFileSync(path.join(emu, file), 'utf8'), sandbox, {filename: file});
}
const keys = {columns: Array.from({length: 8}, () => Array(11).fill(false)),
    alphaLock: true,
    isKeyDown(col, row) {return this.columns[col][row];}, isAlphaLockDown() {return this.alphaLock;},
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
const disk = new sandbox.DiskImage('SEARCH');
const drives = [1,2,3].map(n => new sandbox.DiskDrive('DSK' + n, vdp.ram, n === 1 ? disk : null));
const cpu = new sandbox.TMS9900(memory, cru, keys, drives, []);
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
function text(value) {
    for (const c of value) {
        keys.alphaLock = !/[a-z]/.test(c);
        if (/[A-Z]/.test(c)) press(16, c.charCodeAt(0));
        else if (/[a-z]/.test(c)) press(c.toUpperCase().charCodeAt(0));
        else {
            const code = {' ': 32, '.': 190, ';': 186, ',': 188, '=': 187}[c] || c.charCodeAt(0);
            press(code);
        }
    }
    keys.alphaLock = true;
}
const get = name => memory.getWord(s[name]);
function command() {
    const length = cpu.readMemoryByte(s['cmdb.cmdlen']);
    return {length, value: String.fromCharCode(...Array.from({length}, (_,i) => cpu.readMemoryByte(s['cmdb.cmd'] + i)))};
}
function input(value) {
    press(18, 51); // FCTN-3 clears the command field.
    text(value);
    assert.deepEqual(command(), {length: value.length, value}, 'typed command length and text');
}
const fixture = [
    '* SEARCH FIXTURE', 'INSTAL LWPI MYWS', '       DEF  SETUP,BANK,INSTAL',
    '', 'INSTAL', 'XINSTALY', 'NO MATCH', 'instal lower-case',
];
const fileArg = process.argv.find(a => a.startsWith('--file='))?.slice(7);
let rows;
if (fileArg) {
    const loaded = disk.loadTIFile('XBP14S', fs.readFileSync(fileArg), true);
    assert(loaded, 'TIFILES loaded');
    rows = Array.from(loaded.getRecords(), r => String.fromCharCode(...r.getData()));
} else {
    rows = fixture;
    const file = new sandbox.DiskFile('XBP14S', 0, 1, 80, 0);
    file.open(1, 0);
    for (const row of rows) file.putRecord(new sandbox.VariableRecord(Array.from(row, c => c.charCodeAt(0))));
    file.close();
    disk.putFile(file);
}
function matches(query) {
    const result = [];
    rows.forEach((row, line) => {
        for (let col = row.indexOf(query); col >= 0; col = row.indexOf(query, col + query.length)) result.push([line,col]);
    });
    return result.slice(0, 512);
}
function results(query) {
    const expected = query ? matches(query) : [];
    assert.equal(get('edb.srch.strlen'), query.length, 'search length');
    const actual = Array.from({length: get('edb.srch.matches')}, (_,i) => [
        memory.getWord(s['edb.srch.idx.rtop'] + 2*i), cpu.readMemoryByte(s['edb.srch.idx.ctop'] + i),
    ]);
    assert.deepEqual(actual, expected, 'search results for ' + JSON.stringify(query));
    if (expected.length) {
        assert.equal(get('fb.topline'), expected[0][0], 'first result line');
        assert.equal(get('fb.column'), expected[0][1], 'first result column');
        press(17, 190); // CTRL-. next match.
        run(fileArg ? 200 : 20);
        assert.equal(get('edb.srch.curmatch'), expected.length > 1 ? 1 : 0);
        press(17, 188); // CTRL-, previous match.
        run(fileArg ? 200 : 20);
        assert.equal(get('edb.srch.curmatch'), 0);
    }
    assert.equal(cpu.illegalCount, 0);
    assert.equal(memory.currentCartBank, 1);
    console.log(JSON.stringify({query, matches: actual.length, positions: actual.map(([r,c]) => [r+1,c+1])}));
}
run(180);
press(17, 79); // CTRL-O.
input('DSK1.XBP14S');
press(13);
run(600);
assert.equal(get('edb.lines'), rows.length, 'native disk load record count');
assert.equal(get('tv.pane.focus'), 0, 'editor after disk load');
for (const query of ['INSTAL', 'MYWS', 'SETUP', 'ZZZNOTFOUND', 'instal', '', 'INSTAL']) {
    press(17, 70); // CTRL-F.
    assert.equal(get('cmdb.dialog'), 70, 'find dialog');
    input(query);
    press(13);
    run(fileArg ? 2400 : 400);
    results(query);
}
// Reopen and submit the remembered query without retyping it.
press(17, 70);
assert.deepEqual(command(), {length: 6, value: 'INSTAL'});
press(13); run(fileArg ? 2400 : 400); results('INSTAL');
// Edit a query using the real insert/delete and cursor handlers.
press(17, 70); input('INSTA'); text('L');
assert.deepEqual(command(), {length: 6, value: 'INSTAL'});
press(18, 83); press(18, 49); // Left, delete L.
assert.deepEqual(command(), {length: 5, value: 'INSTA'});
text('L');
press(18, 83); press(18, 83); // Before A.
text('X');
assert.deepEqual(command(), {length: 7, value: 'INSTXAL'});
press(18, 83); press(18, 49); // Delete inserted X.
assert.deepEqual(command(), {length: 6, value: 'INSTAL'});
press(13); run(fileArg ? 2400 : 400); results('INSTAL');
console.log(JSON.stringify({passed: true, mode, records: rows.length, file: fileArg || 'synthetic fixture', image}));

// Runs the native cartridge with an in-memory emulated disk; no user files are written.
const fs = require('node:fs');
const path = require('node:path');
const Module = require('node:module');
const source = path.resolve(__dirname, 'test_search.cjs');
let prefix = fs.readFileSync(source, 'utf8').split('const fixture = [')[0];
const factor = Number(process.argv.find(a => a.startsWith('--cpu-factor='))?.split('=')[1] || 1);
prefix = prefix.replace('slice < 50;', `slice < ${50 * factor};`);
const body = String.raw`
const total = 4000;
const lengths = [0,1,2,3,15,16,17,31,32,33,63,79,80];
let rows = Array.from({length: total}, (_,i) => {
    const n = lengths[i % lengths.length];
    return (String(i).padStart(6,'0') + ' ' + String.fromCharCode(65+i%26).repeat(80)).slice(0,n);
});
const file = new sandbox.DiskFile('SOURCE', 0, 1, 80, 0);
file.open(1, 0);
for (const row of rows) file.putRecord(new sandbox.VariableRecord(Array.from(row, c => c.charCodeAt(0))));
file.close(); disk.putFile(file);
const wait = n => run(Math.ceil(n / CPU_FACTOR) + 40);
let dialogData;
function save(name) {
    press(17, 83); assert.equal(get('cmdb.dialog'), 13, 'save dialog');
    input('DSK1.' + name); press(13); wait(2400);
    const result = disk.getFile(name);
    assert(result, 'saved file exists');
    const actual = Array.from(result.getRecords(), r => String.fromCharCode(...r.getData()));
    const errors = [];
    for (let i=0; i<Math.max(rows.length,actual.length); i++) {
        if (actual[i] !== rows[i]) errors.push({line:i+1, expected:rows[i], actual:actual[i]});
    }
    console.log(JSON.stringify({name, count:actual.length, errors:errors.length, examples:errors.slice(0,12),
        highPage:get('edb.sams.hipage'), currentPage:get('tv.sams.c000'), locked:get('edb.locked'), focus:get('tv.pane.focus'), dialog:get('cmdb.dialog')}));
    assert.equal(errors.length, 0, 'record content preserved');
    assert.deepEqual(memory.ams.ram.slice(2*4096,4*4096), dialogData,
        'dialog strings and marker data were not overwritten by the line index');
    assert.equal(cpu.illegalCount, 0);
    assert.equal(memory.currentCartBank, 1);
}
run(180);
dialogData = memory.ams.ram.slice(2*4096,4*4096);
press(17,79);input('DSK1.SOURCE');press(13);wait(2400);
assert.equal(get('edb.lines'), total, 'all source records loaded');
save('UNEDITED');
press(17,85); // Stevie locks the editor after saving; unlock before editing.
assert.equal(get('edb.locked'), 0);
for (const line of [0,1,47,48,49,50,85,86,127,128,255,256,511,512,1023,1024,2047,2048,3999]) {
    press(17,71);input(String(line+1));press(13);wait(80);
    assert.equal(get('fb.topline') + get('fb.row'), line, 'goto line');
    // Leave room for the inserted character on a full D/V80 record.
    if (rows[line].length===80) {
        press(18,49); rows[line]=rows[line].slice(1);
    }
    const before = get('fb.column');
    text('Z');

    assert.equal(get('fb.column'), before+1, 'typed character accepted');
    rows[line]='Z'+rows[line];
}
save('EDITED');
save('RESAVED');
for (const line of [0,2047,2048,3999]) {
    press(17,85);
    press(17,71);input(String(line+1));press(13);wait(80);
    const before=get('fb.column'); text('Q');
    assert.equal(get('fb.column'),before+1,'checkpoint edit accepted');
    rows[line]='Q'+rows[line];
    // Save immediately, without moving off the changed row.
    save('CHECK'+String(line));
}

console.log(JSON.stringify({passed:true, records:total, cpuFactor:CPU_FACTOR, mode}));
`.replaceAll('CPU_FACTOR', String(factor));
const script = new Module(source, module);
script.filename = source;
script.paths = Module._nodeModulePaths(path.dirname(source));
script._compile(prefix + body, source);

const fs = require('node:fs');
const path = require('node:path');
const Module = require('node:module');
const source = path.resolve(__dirname, 'test_search.cjs');
let prefix = fs.readFileSync(source, 'utf8').split('const fixture = [')[0];
const factor = Number(process.argv.find(a => a.startsWith('--cpu-factor='))?.split('=')[1] || 1);
prefix = prefix.replace('slice < 50;', `slice < ${50 * factor};`);
const body = String.raw`
const total = Number(process.argv.find(a=>a.startsWith('--records='))?.split('=')[1] || 1910);
const insertAt = Number(process.argv.find(a=>a.startsWith('--at='))?.split('=')[1] || 1000);
const importPath = process.argv.find(a=>a.startsWith('--import='))?.slice(9);
let extra;
if(importPath) {
    const imported = disk.loadTIFile('IMPORT', fs.readFileSync(importPath), true);
    assert(imported, 'import TIFILES loaded');
    extra = Array.from(imported.getRecords(), r => String.fromCharCode(...r.getData()));
} else {
    const lengths=[70,66,1,51,35,80,18,63];
    extra=Array.from({length:138},(_,i)=>('IMPORTED '+String(i).padStart(4,'0')+' '+String.fromCharCode(65+i%26).repeat(80)).slice(0,lengths[i%lengths.length]));
    extra[119]='       BLWP @GPLLNK                Execute DSR LINK';
    const file=new sandbox.DiskFile('IMPORT',0,1,80,0);file.open(1,0);
    for(const row of extra)file.putRecord(new sandbox.VariableRecord(Array.from(row,c=>c.charCodeAt(0))));
    file.close();disk.putFile(file);
}
const basePath = process.argv.find(a=>a.startsWith('--base='))?.slice(7);
let rows;
if (basePath) {
    const file=disk.loadTIFile('SOURCE',fs.readFileSync(basePath),true);assert(file);
    rows=Array.from(file.getRecords(),r=>String.fromCharCode(...r.getData()));
} else {
    rows = Array.from({length: total}, (_,i) => String(i).padStart(6,'0') + ' ' + String.fromCharCode(65+i%26).repeat(35));
    const file = new sandbox.DiskFile('SOURCE', 0, 1, 80, 0);
    file.open(1, 0);
    for (const row of rows) file.putRecord(new sandbox.VariableRecord(Array.from(row, c => c.charCodeAt(0))));
    file.close(); disk.putFile(file);
}
const wait = n => run(Math.ceil(n / CPU_FACTOR) + 60);
const ram=memory.ams.ram;
function packedLine(line) {
    const index=(get('idx.sams.lopage')+Math.floor(line/2048))*4096 + 2*(line%2048);
    const entry=(ram[index]<<8)|ram[index+1];
    if (!entry) return '';
    const address=(entry>>>8)*4096+(entry&255)*16;
    const length=(ram[address]<<8)|ram[address+1];
    return String.fromCharCode(...ram.slice(address+2,address+2+length));
}
function compare(actual,label) {
    const errors=[];
    for (let i=0;i<Math.max(rows.length,actual.length);i++) {
        if(rows[i]!==actual[i]) {
            const at=(get('idx.sams.lopage')+Math.floor(i/2048))*4096 + 2*(i%2048);
            errors.push({line:i+1,importRecord:i-insertAt+1,expected:rows[i],actual:actual[i]?.slice(0,160),actualLength:actual[i]?.length,entry:((ram[at]<<8)|ram[at+1]).toString(16)});
        }
    }
    console.log(JSON.stringify({label,records:actual.length,errors:errors.length,examples:errors.slice(0,10)}));
    return errors.length;
}
run(180);
press(17,79);input('DSK1.SOURCE');press(13);wait(2400);
assert.equal(get('edb.lines'),rows.length,'loaded source');
press(17,85);
press(17,71);input(String(insertAt));press(13);wait(80);
assert.equal(get('fb.topline')+get('fb.row'),insertAt-1);
if(process.argv.includes('--dirty')) {
    text('Z');rows[insertAt-1]='Z'+rows[insertAt-1];
}
if(process.argv.includes('--newline')) {
    press(18,56);wait(160);
    rows.splice(insertAt-1,0,'');
} else {
    press(17,73);assert.equal(get('cmdb.dialog'),11);
    input('DSK1.IMPORT');press(13);wait(3200);
    rows.splice(insertAt,0,...extra);
}
console.log(JSON.stringify({stage:'inserted',expected:rows.length,actual:get('edb.lines'),importRecords:process.argv.includes('--newline')?1:extra.length,insertAt,highPage:get('edb.sams.hipage')}));
assert.equal(get('edb.lines'),rows.length,'inserted row count');
const packedErrors=compare(Array.from({length:rows.length},(_,i)=>packedLine(i)),'packed buffer after insertion');
press(17,83);input('DSK1.RESULT');press(13);wait(2400);
const saved=disk.getFile('RESULT');assert(saved,'saved result');
const savedErrors=compare(Array.from(saved.getRecords(),r=>String.fromCharCode(...r.getData())),'saved result');
assert.equal(packedErrors,0,'packed rows retained');assert.equal(savedErrors,0,'saved rows retained');
assert.equal(cpu.illegalCount,0);assert.equal(memory.currentCartBank,1);
console.log(JSON.stringify({passed:true,mode,cpuFactor:CPU_FACTOR,records:rows.length,importPath:importPath || 'synthetic fixture',newline:process.argv.includes('--newline'),dirty:process.argv.includes('--dirty')}));
`.replaceAll('CPU_FACTOR', String(factor));
const script = new Module(source, module);
script.filename = source;
script.paths = Module._nodeModulePaths(path.dirname(source));
script._compile(prefix + body, source);

const fs=require('node:fs'),path=require('node:path'),Module=require('node:module');
const source=path.resolve(__dirname,'test_file_insert.cjs');
const extra=String.raw`
function go(line) {press(17,71);input(String(line));press(13);wait(120);}
function decInfo(label) {
    const line=rows.findLastIndex(r=>r.trim()==='DEC  R3');
    const index=(get('idx.sams.lopage')+Math.floor(line/2048))*4096+2*(line%2048);
    const entry=(ram[index]<<8)|ram[index+1];
    const value=packedLine(line);
    console.log(JSON.stringify({label,line:line+1,entry:entry.toString(16),value,map:memory.ams.registerMap[12],count:get('edb.lines')}));
}
const extraLines=Number(process.argv.find(a=>a.startsWith('--extra-lines='))?.split('=')[1] ?? 5);
const deletions=Number(process.argv.find(a=>a.startsWith('--deletions='))?.split('=')[1] ?? 2);
const dec=rows.findLastIndex(r=>r.trim()==='DEC  R3');
const at=process.argv.includes('--tail') ? rows.length : Number(process.argv.find(a=>a.startsWith('--delete-at='))?.split('=')[1] || (dec>=0 ? dec+1 : rows.length-10));
console.log(JSON.stringify({deletionTest:true,at,extraLines,deletions,startCount:rows.length}));
go(at);
for(let n=0;n<extraLines;n++) {press(18,56);wait(60);rows.splice(get('fb.topline')+get('fb.row'),0,'');}
for(let n=0;n<deletions;n++) {
    const line=get('fb.topline')+get('fb.row');
    press(18,51);wait(60);rows.splice(line,1);
    assert.equal(get('edb.lines'),rows.length,'line count after deletion');
}
if(dec>=0)decInfo('DEC R3 after deletions');

`;
let text=fs.readFileSync(source,'utf8').replace('const packedErrors=compare(',extra+'\nconst packedErrors=compare(');
const m=new Module(source,module);m.filename=source;m.paths=Module._nodeModulePaths(path.dirname(source));m._compile(text,source);

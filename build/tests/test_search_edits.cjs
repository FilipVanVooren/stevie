// Native search/edit/navigation/save regression tests. No user files are modified.
const fs=require('node:fs'),path=require('node:path'),Module=require('node:module');
const source=path.resolve(__dirname,'test_search.cjs');
const prefix=fs.readFileSync(source,'utf8').split('const fixture = [')[0];
const body=String.raw`
const scenario=process.argv.find(a=>a.startsWith('--case='))?.slice(7)||'next';
const large=process.argv.includes('--large');
const total=large?2200:120;
const rows=Array.from({length:total},(_,i)=>'ROW '+String(i).padStart(5,'0')+' ALPHA BETA');
const hits=large?[0,10,2047,2048,2199]:[0,10,119];
for(const i of hits)rows[i]='FIND ALPHA BETA';
if(scenario==='same-line')rows[0]='FIND ALPHA FIND BETA';
if(scenario==='adjacent')rows[0]='FINDFIND';
const file=new sandbox.DiskFile('SOURCE',0,1,80,0);file.open(1,0);
for(const row of rows)file.putRecord(new sandbox.VariableRecord(Array.from(row,c=>c.charCodeAt(0))));
file.close();disk.putFile(file);
const ram=memory.ams.ram;
function packed(line) {
    const at=(get('idx.sams.lopage')+Math.floor(line/2048))*4096+2*(line%2048);
    const entry=(ram[at]<<8)|ram[at+1];if(!entry)return '';
    const base=(entry>>>8)*4096+(entry&255)*16;
    const length=(ram[base]<<8)|ram[base+1];assert(length<=80,'valid packed record length');
    return String.fromCharCode(...ram.slice(base+2,base+2+length));
}
function compare(actual,label) {
    const errors=[];
    for(let i=0;i<Math.max(rows.length,actual.length);i++)if(rows[i]!==actual[i])errors.push({line:i+1,expected:rows[i],actual:actual[i]});
    console.log(JSON.stringify({label,case:scenario,errors:errors.length,examples:errors.slice(0,4)}));
    assert.equal(errors.length,0,label);
}
function find(query) {
    press(17,70);assert.equal(get('cmdb.dialog'),70);input(query);press(13);run(large?1600:200);
}
function edit() {
    const line=get('fb.topline')+get('fb.row'),col=get('fb.column');
    text('Z');rows[line]=rows[line].slice(0,col)+'Z'+rows[line].slice(col);
    assert.equal(get('fb.row.dirty'),0xffff,'edit pending');
}
run(180);press(17,79);input('DSK1.SOURCE');press(13);run(large?1600:250);
press(17,85);
if(scenario==='start') {
    edit();find('Z');assert.equal(get('edb.srch.matches'),1,'search includes pending edit');
} else {
    find('FIND');assert.equal(get('edb.srch.matches'),hits.length+(['same-line','adjacent'].includes(scenario)?1:0));
    if(scenario==='large-next') {
        press(17,190);run(200);press(17,190);run(200);
        assert.equal(get('fb.topline'),2047);
    }
    edit();
    if(scenario==='previous')press(17,188);
    else if(scenario==='new-search')find('Z');
    else if(scenario==='cancel') {
        press(17,70);press(18,57);if(get('cmdb.visible'))press(18,57);
    }
    else if(scenario==='clear')press(17,52);
    else press(17,190);
    run(100);
}
if(scenario!=='clear')compare(Array.from({length:rows.length},(_,i)=>packed(i)),'packed search edits');
press(17,83);input('DSK1.RESULT');press(13);run(large?1800:300);
const result=disk.getFile('RESULT');assert(result);
compare(Array.from(result.getRecords(),r=>String.fromCharCode(...r.getData())),'saved search edits');
assert.equal(cpu.illegalCount,0);assert.equal(memory.currentCartBank,1);
console.log(JSON.stringify({passed:true,mode,case:scenario,records:rows.length}));
`;
const script=new Module(source,module);script.filename=source;
script.paths=Module._nodeModulePaths(path.dirname(source));script._compile(prefix+body,source);

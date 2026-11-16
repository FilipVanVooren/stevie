// Execute held editor navigation commands and verify the resulting file contents.
const fs=require('node:fs'),path=require('node:path'),Module=require('node:module');
const source=path.resolve(__dirname,'test_search.cjs');
const prefix=fs.readFileSync(source,'utf8').split('const fixture = [')[0];
const body=String.raw`
const rows=Array.from({length:2200},(_,i)=>i%17===0?'FIND ALPHA BETA':'A B C D E F G H I J K L M N O P Q R S T U V W X Y Z');
const file=new sandbox.DiskFile('SOURCE',0,1,80,0);file.open(1,0);
for(const row of rows)file.putRecord(new sandbox.VariableRecord(Array.from(row,c=>c.charCodeAt(0))));
file.close();disk.putFile(file);
const set=(name,value)=>cpu.writeMemoryWord(s[name],value);
function keysDown(codes) {
    globalKeys.columns.forEach(c=>c.fill(false));
    for(const keyCode of codes)sandbox.Keyboard.prototype.keyEvent.call(globalKeys,{keyCode,preventDefault(){}},true);
}
function go(line) {press(17,71);input(String(line));press(13);run(150);}
let watching=null,events=[];
const execute=cpu.execute;
cpu.execute=function(instruction) {
    if(watching && memory.currentCartBank===1 && ((this.PC-2)&65535)===s['edk.act.'+watching]) {
        events.push({frame:count,line:get('fb.topline')+get('fb.row'),column:get('fb.column')});
        if(watching==='enter' && get('edb.autoinsert') && get('edb.insmode')) {
            rows.splice(get('fb.topline')+get('fb.row')+1,0,'');
        }
    }
    return execute.call(this,instruction);
};
function hold(label,codes) {
    watching=label;events=[];keysDown(codes);run(180);keysDown([]);run(180);
    assert(events.length>=2,label+' actually repeated');
    const amount=events.length,position=[get('fb.topline'),get('fb.row'),get('fb.column'),get('edb.srch.curmatch')];
    run(50);assert.equal(events.length,amount,label+' stopped on release');
    assert.deepEqual([get('fb.topline'),get('fb.row'),get('fb.column'),get('edb.srch.curmatch')],position);
    watching=null;assert.equal(cpu.illegalCount,0);assert.equal(memory.currentCartBank,1);
    console.log(JSON.stringify({action:label,executions:amount,position}));
    return events;
}
run(180);press(17,79);input('DSK1.SOURCE');press(13);run(1800);press(17,85);
set('edb.autoinsert',0);go(100);const enterMove=hold('enter',[13]);
assert.equal(get('edb.lines'),rows.length);assert.equal(get('fb.topline')+get('fb.row'),99+enterMove.length);
set('edb.autoinsert',0xffff);go(2045);hold('enter',[13]);set('edb.autoinsert',0);
assert.equal(get('edb.lines'),rows.length,'held ENTER inserts the expected blank rows');
go(11);const start=get('fb.column');hold('nword',[18,75]);assert(get('fb.column')>start);
press(18,76);const end=get('fb.column');hold('pword',[18,74]);assert(get('fb.column')<end);
go(100);const page=get('fb.topline');hold('npage',[18,52]);assert(get('fb.topline')>page);
go(1500);const later=get('fb.topline');hold('ppage',[18,54]);assert(get('fb.topline')<later);
// Holding ENTER submits Find once. A context change must not create editor newlines.
press(17,70);input('FIND');const beforeFind=rows.length;
keysDown([13]);run(180);keysDown([]);run(1800);
assert.equal(get('edb.lines'),beforeFind);assert(get('edb.srch.matches')>2);
assert.deepEqual([get('fb.topline'),get('fb.row'),get('fb.column')],[0,0,0],
    'held dialog ENTER must not turn into editor newline navigation');
const first=get('fb.topline')+get('fb.row'),col=get('fb.column');
text('Z');rows[first]=rows[first].slice(0,col)+'Z'+rows[first].slice(col);
hold('goto.nmatch',[17,190]);
const current=get('fb.topline')+get('fb.row'),currentCol=get('fb.column');
text('Q');rows[current]=rows[current].slice(0,currentCol)+'Q'+rows[current].slice(currentCol);
hold('goto.pmatch',[17,188]);
press(17,83);input('DSK1.RESULT');press(13);run(2000);
const result=disk.getFile('RESULT');assert(result);
const actual=Array.from(result.getRecords(),r=>String.fromCharCode(...r.getData()));
assert.deepEqual(actual,rows,'all records and search edits survive repeated navigation and save');
console.log(JSON.stringify({passed:true,mode,records:rows.length}));
`;
// Keep the emulator keyboard binding available without shadowing its lexical name.
const script=new Module(source,module);script.filename=source;
script.paths=Module._nodeModulePaths(path.dirname(source));
script._compile(prefix+'\nconst globalKeys=keys;\n'+body,source);

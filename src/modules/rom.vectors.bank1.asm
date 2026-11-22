* FILE......: rom.vectors.bank1.asm
* Purpose...: Bank 1 vectors for trampoline function

*--------------------------------------------------------------
* ROM 1: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  mem.sams.setup.stevie ;
vec.2   data  tv.clock.start        ; Start clock task
vec.3   data  edb.line.pack.fb      ;
vec.4   data  edb.line.unpack.fb    ;
vec.5   data  edk.act.cmdb.show     ;
vec.6   data  cmdb.dialog.close     ;
vec.7   data  fb.vdpdump            ;
vec.8   data  pane.errline.hide     ;
vec.9   data  pane.cursor.blink     ;
vec.10  data  pane.cursor.hide      ;
vec.11  data  pane.errline.show     ;
vec.12  data  cpu.crash             ;
vec.13  data  cpu.crash             ;
vec.14  data  cpu.crash             ;
vec.15  data  cpu.crash             ;
vec.16  data  cpu.crash             ;
vec.17  data  cpu.crash             ;
vec.18  data  cpu.crash             ;
vec.19  data  cpu.crash             ;
vec.20  data  cpu.crash             ;
vec.21  data  cpu.crash             ;
vec.22  data  cpu.crash             ;
vec.23  data  cpu.crash             ;
vec.24  data  cpu.crash             ;
vec.25  data  cpu.crash             ;
vec.26  data  cpu.crash             ;
vec.27  data  cpu.crash             ;
vec.28  data  cpu.crash             ;
vec.29  data  cpu.crash             ;
vec.30  data  cpu.crash             ;
vec.31  data  cpu.crash             ;
vec.32  data  cpu.crash             ;

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        aorg >7fea
        stri 'ROM#1'

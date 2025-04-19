* FILE......: rom.vectors.bank1.asm
* Purpose...: Bank 1 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#1'
*--------------------------------------------------------------
* ROM 1: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   data  mem.sams.setup.stevie ;
vec.2   data  cpu.crash             ;
vec.3   data  cpu.crash             ;
vec.4   data  cpu.crash             ;
vec.5   data  cpu.crash             ;
vec.6   data  cpu.crash             ;
vec.7   data  cpu.crash             ;
vec.8   data  cpu.crash             ;
vec.9   data  cpu.crash             ;
vec.10  data  edb.line.pack.fb      ;
vec.11  data  edb.line.unpack.fb    ;
vec.12  data  edb.clear.sams        ;
vec.13  data  cpu.crash             ;
vec.14  data  cpu.crash             ;
vec.15  data  edkey.action.cmdb.show
vec.16  data  cpu.crash             ;
vec.17  data  cpu.crash             ;
vec.18  data  cmdb.dialog.close     ;
vec.19  data  cmdb.cmd.clear        ;
vec.20  data  cpu.crash             ;
vec.21  data  fb.vdpdump            ;
vec.22  data  fb.row2line           ;
vec.23  data  cpu.crash             ;
vec.24  data  cpu.crash             ;
vec.25  data  cpu.crash             ;
vec.26  data  cpu.crash             ;
vec.27  data  pane.errline.hide     ;
vec.28  data  pane.cursor.blink     ;
vec.29  data  pane.cursor.hide      ;
vec.30  data  pane.errline.show     ;
vec.31  data  pane.colorscheme.load
vec.32  data  pane.colorscheme.botline
*--------------------------------------------------------------
* ROM 1: Vectors 33-64
*--------------------------------------------------------------
vec.33  data  cpu.crash             ;
vec.34  data  cpu.crash             ;
vec.35  data  cpu.crash             ;
vec.36  data  cpu.crash             ;
vec.37  data  cpu.crash             ;
vec.38  data  cpu.crash             ;
vec.39  data  cpu.crash             ;
vec.40  data  cpu.crash             ;
vec.41  data  cpu.crash             ;
vec.42  data  cpu.crash             ;
vec.43  data  cpu.crash             ;
vec.44  data  cpu.crash             ;
vec.45  data  cpu.crash             ;
vec.46  data  cpu.crash             ;
vec.47  data  cpu.crash             ;
vec.48  data  cpu.crash             ;
vec.49  data  cpu.crash             ;
vec.50  data  cpu.crash             ;
vec.51  data  cpu.crash             ;
vec.52  data  cpu.crash             ;
vec.53  data  cpu.crash             ;
vec.54  data  cpu.crash             ;
vec.55  data  cpu.crash             ;
vec.56  data  cpu.crash             ;
vec.57  data  cpu.crash             ;
vec.58  data  cpu.crash             ;
vec.59  data  cpu.crash             ;
vec.60  data  cpu.crash             ;
vec.61  data  cpu.crash             ;
vec.62  data  cpu.crash             ;
vec.63  data  cpu.crash             ;
vec.64  data  cpu.crash             ;

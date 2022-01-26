* FILE......: rom.vectors.bank7.asm
* Purpose...: Bank 7 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        #string 'ROM#7'

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
        aorg  bankx.vectab

vec.1   data  mem.sams.set.legacy   ;
vec.2   data  mem.sams.set.boot     ;
vec.3   data  mem.sams.set.stevie   ;
vec.4   data  mem.sams.set.external ;
vec.5   data  mem.sams.set.basic1   ;
vec.6   data  mem.sams.set.basic2   ;
vec.7   data  mem.sams.set.basic3   ;
vec.8   data  mem.sams.set.basic4   ;
vec.9   data  mem.sams.set.basic5   ;
vec.10  data  tibasic               ;
vec.11  data  cpu.crash             ;
vec.12  data  cpu.crash             ;
vec.13  data  cpu.crash             ;
vec.14  data  cpu.crash             ;
vec.15  data  cpu.crash             ;
vec.16  data  cpu.crash             ;
vec.17  data  cpu.crash             ;
vec.18  data  cpu.crash             ;
vec.19  data  cpu.crash             ;
vec.20  data  magic.set             ;
vec.21  data  magic.clear           ;
vec.22  data  magic.check           ;
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

* FILE......: rom.vectors.bank7.asm
* Purpose...: Bank 7 vectors for trampoline function

*--------------------------------------------------------------
* ROM 7: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  mem.sams.set.legacy   ;
vec.2   data  mem.sams.set.boot     ;
vec.3   data  mem.sams.set.stevie   ;
vec.4   data  tib.run               ;
vec.5   data  tib.uncrunch          ;
vec.6   data  mem.run.ea5           ; Run EA5 binary image in memory
vec.7   data  tv.reset              ;
vec.8   data  cart.fg99.mgr         ; FinalGROM 99
vec.9   data  cpu.crash             ;
vec.10  data  cpu.crash             ;
vec.11  data  cpu.crash             ;
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
        stri 'ROM#7'

* FILE......: rom.vectors.bank5.asm
* Purpose...: Bank 5 vectors for trampoline function

*--------------------------------------------------------------
* ROM 5: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  edb.clear.sams        ;
vec.2   data  edb.block.mark        ;
vec.3   data  edb.block.mark.m1     ;
vec.4   data  edb.block.mark.m2     ;
vec.5   data  edb.block.clip        ;
vec.6   data  edb.block.reset       ;
vec.7   data  edb.block.delete      ;
vec.8   data  edb.block.copy        ;
vec.9   data  edb.line.del          ;
vec.10  data  edb.block.match       ;
vec.11  data  edb.lock              ;
vec.12  data  edb.unlock            ;
vec.13  data  edb.find.init         ;
vec.14  data  edb.find.search       ;
vec.15  data  pane.clock.time       ;
vec.16  data  fm.clock.off          ;
vec.17  data  tv.flash.screen       ;
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
        stri 'ROM#5'

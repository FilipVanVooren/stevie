* FILE......: rom.vectors.bank5.asm
* Purpose...: Bank 5 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#5'

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
        aorg  bankx.vectab

vec.1   data  edb.clear.sams        ;
vec.2   data  cpu.crash             ;
vec.3   data  edb.block.mark        ;
vec.4   data  edb.block.mark.m1     ;
vec.5   data  edb.block.mark.m2     ;
vec.6   data  edb.block.clip        ;
vec.7   data  edb.block.reset       ;
vec.8   data  edb.block.delete      ;
vec.9   data  edb.block.copy        ;
vec.10  data  edb.line.del          ;
vec.11  data  edb.line.copy         ;
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

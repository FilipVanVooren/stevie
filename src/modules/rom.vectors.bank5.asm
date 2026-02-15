* FILE......: rom.vectors.bank5.asm
* Purpose...: Bank 5 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#5'

*--------------------------------------------------------------
* ROM 5: Vectors 1-32
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
vec.12  data  edb.block.match       ;
vec.13  data  edb.lock              ;
vec.14  data  edb.unlock            ;
vec.15  data  edb.find.init         ;
vec.16  data  edb.find.search       ;
vec.17  data  edb.find.scan         ;
vec.18  data  cpu.crash             ;
vec.19  data  cpu.crash             ;
vec.20  data  cpu.crash             ;
vec.21  data  cpu.crash             ;
vec.22  data  cpu.crash             ;
vec.23  data  cpu.crash             ;
vec.24  data  cpu.crash             ;
vec.25  data  pane.clock.time       ; 
vec.26  data  fm.clock.on           ;
vec.27  data  fm.clock.off          ;
vec.28  data  tv.flash.screen       ;
vec.29  data  cpu.crash             ;
vec.30  data  cpu.crash             ;
vec.31  data  cpu.crash             ;
vec.32  data  cpu.crash             ;
*--------------------------------------------------------------
* ROM 5: Vectors 33-64 (DEPRECATED! WILL BE REMOVED)
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

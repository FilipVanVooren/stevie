* FILE......: rom.vectors.bank2.asm
* Purpose...: Bank 2 vectors for trampoline function

*--------------------------------------------------------------
* ROM 2: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  fm.loadfile           ;
vec.2   data  fm.insertfile         ;
vec.3   data  fm.run.ea5            ;
vec.4   data  fm.savefile           ;
vec.5   data  fm.newfile            ;
vec.6   data  fm.directory          ;
vec.7   data  fm.browse.fname.prev  ;
vec.8   data  fm.browse.fname.next  ;
vec.9   data  fm.browse.fname.set   ;
vec.10  data  fm.browse.updir       ;
vec.11  data  fm.clock.read         ;
vec.12  data  fm.delfile            ;
vec.13  data  file.vmem             ;
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
        stri 'ROM#2'

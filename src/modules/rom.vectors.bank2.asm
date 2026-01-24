* FILE......: rom.vectors.bank2.asm
* Purpose...: Bank 2 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#2'

*--------------------------------------------------------------
* ROM 2: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   data  fm.loadfile           ;
vec.2   data  fm.insertfile         ;
vec.3   data  fm.run.ea5            ;
vec.4   data  fm.savefile           ;
vec.5   data  fm.newfile            ;
vec.6   data  fm.directory          ;
vec.7   data  fh.file.read.mem      ;
vec.8   data  fh.file.read.edb      ;
vec.9   data  fh.file.write.edb     ;
vec.10  data  fm.browse.fname.prev  ;
vec.11  data  fm.browse.fname.next  ;
vec.12  data  fm.browse.fname.set   ;
vec.13  data  fm.browse.updir       ;
vec.14  data  fm.read.clock         ;
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
vec.32  data  file.vmem             ;
*--------------------------------------------------------------
* ROM 2: Vectors 33-64 (DEPRECATED! WILL BE REMOVED)
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

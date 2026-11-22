* FILE......: rom.vectors.bank8.asm
* Purpose...: Bank 8 vectors for trampoline function

*--------------------------------------------------------------
* ROM 8: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  edkey.key.repeat      ; Update keyboard autorepeat
vec.2   data  0                     ;
vec.3   data  0                     ;
vec.4   data  0                     ;
vec.5   data  0                     ;
vec.6   data  0                     ;
vec.7   data  0                     ;
vec.8   data  0                     ;
vec.9   data  0                     ;
vec.10  data  0                     ;
vec.11  data  0                     ;
vec.12  data  0                     ;
vec.13  data  0                     ;
vec.14  data  0                     ;
vec.15  data  0                     ;
vec.16  data  0                     ;
vec.17  data  0                     ;
vec.18  data  0                     ;
vec.19  data  0                     ;
vec.20  data  0                     ;
vec.21  data  0                     ;
vec.22  data  0                     ;
vec.23  data  0                     ;
vec.24  data  0                     ;
vec.25  data  0                     ;
vec.26  data  0                     ;
vec.27  data  0                     ;
vec.28  data  0                     ;
vec.29  data  0                     ;
vec.30  data  0                     ;
vec.31  data  0                     ;
vec.32  data  0                     ;

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        aorg >7fea
        stri 'ROM#8'

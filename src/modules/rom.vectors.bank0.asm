* FILE......: rom.vectors.bank0.asm
* Purpose...: Bank 0 "dummy" vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#0'
*--------------------------------------------------------------
* ROM 0: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   equ   bankx.vectab          ;
vec.2   equ   bankx.vectab + 2      ;
vec.3   equ   bankx.vectab + 4      ;
vec.4   equ   bankx.vectab + 6      ;
vec.5   equ   bankx.vectab + 8      ;
vec.6   equ   bankx.vectab + 10     ;
vec.7   equ   bankx.vectab + 12     ;
vec.8   equ   bankx.vectab + 14     ;
vec.9   equ   bankx.vectab + 16     ;
vec.10  equ   bankx.vectab + 18     ;
vec.11  equ   bankx.vectab + 20     ;
vec.12  equ   bankx.vectab + 22     ;
vec.13  equ   bankx.vectab + 24     ;
vec.14  equ   bankx.vectab + 26     ;
vec.15  equ   bankx.vectab + 28     ;
vec.16  equ   bankx.vectab + 30     ;
vec.17  equ   bankx.vectab + 32     ;
vec.18  equ   bankx.vectab + 34     ;
vec.19  equ   bankx.vectab + 36     ;
vec.20  equ   bankx.vectab + 38     ;
vec.21  equ   bankx.vectab + 40     ;
vec.22  equ   bankx.vectab + 42     ;
vec.23  equ   bankx.vectab + 44     ;
vec.24  equ   bankx.vectab + 46     ;
vec.25  equ   bankx.vectab + 48     ;
vec.26  equ   bankx.vectab + 50     ;
vec.27  equ   bankx.vectab + 52     ;
vec.28  equ   bankx.vectab + 54     ;
vec.29  equ   bankx.vectab + 56     ;
vec.30  equ   bankx.vectab + 58     ;
vec.31  equ   bankx.vectab + 60     ;
vec.32  equ   bankx.vectab + 62     ;
*--------------------------------------------------------------
* ROM 0: Vectors 33-64
*--------------------------------------------------------------
vec.33  equ   bankx.vectab + 64     ;
vec.34  equ   bankx.vectab + 66     ;
vec.35  equ   bankx.vectab + 68     ;
vec.36  equ   bankx.vectab + 70     ;
vec.37  equ   bankx.vectab + 72     ;
vec.38  equ   bankx.vectab + 74     ;
vec.39  equ   bankx.vectab + 76     ;
vec.40  equ   bankx.vectab + 78     ;
vec.41  equ   bankx.vectab + 80     ;
vec.42  equ   bankx.vectab + 82     ;
vec.43  equ   bankx.vectab + 84     ;
vec.44  equ   bankx.vectab + 86     ;
vec.45  equ   bankx.vectab + 88     ;
vec.46  equ   bankx.vectab + 90     ;
vec.47  equ   bankx.vectab + 92     ;
vec.48  equ   bankx.vectab + 94     ;
vec.49  equ   bankx.vectab + 96     ;
vec.50  equ   bankx.vectab + 98     ;
vec.51  equ   bankx.vectab + 100    ;
vec.52  equ   bankx.vectab + 102    ;
vec.53  equ   bankx.vectab + 104    ;
vec.54  equ   bankx.vectab + 106    ;
vec.55  equ   bankx.vectab + 108    ;
vec.56  equ   bankx.vectab + 110    ;
vec.57  equ   bankx.vectab + 112    ;
vec.58  equ   bankx.vectab + 114    ;
vec.59  equ   bankx.vectab + 116    ;
vec.60  equ   bankx.vectab + 118    ;
vec.61  equ   bankx.vectab + 120    ;
vec.62  equ   bankx.vectab + 122    ;
vec.63  equ   bankx.vectab + 124    ;
vec.64  equ   bankx.vectab + 126    ;
*--------------------------------------------------------------
* ROM 0: Vectors 65-96
*--------------------------------------------------------------
vec.65  equ   bankx.vectab + 128    ;
vec.66  equ   bankx.vectab + 130    ;
vec.67  equ   bankx.vectab + 132    ;
vec.68  equ   bankx.vectab + 134    ;
vec.69  equ   bankx.vectab + 136    ;
vec.70  equ   bankx.vectab + 138    ;
vec.71  equ   bankx.vectab + 140    ;
vec.72  equ   bankx.vectab + 142    ;
vec.73  equ   bankx.vectab + 144    ;
vec.74  equ   bankx.vectab + 146    ;
vec.75  equ   bankx.vectab + 148    ;
vec.76  equ   bankx.vectab + 150    ;
vec.77  equ   bankx.vectab + 152    ;
vec.78  equ   bankx.vectab + 154    ;
vec.79  equ   bankx.vectab + 156    ;
vec.80  equ   bankx.vectab + 158    ;
vec.81  equ   bankx.vectab + 160    ;
vec.82  equ   bankx.vectab + 162    ;
vec.83  equ   bankx.vectab + 164    ;
vec.84  equ   bankx.vectab + 166    ;
vec.85  equ   bankx.vectab + 168    ;
vec.86  equ   bankx.vectab + 170    ;
vec.87  equ   bankx.vectab + 172    ;
vec.88  equ   bankx.vectab + 174    ;
vec.89  equ   bankx.vectab + 176    ;
vec.90  equ   bankx.vectab + 178    ;
vec.91  equ   bankx.vectab + 180    ;
vec.92  equ   bankx.vectab + 182    ;
vec.93  equ   bankx.vectab + 184    ;
vec.94  equ   bankx.vectab + 186    ;
vec.95  equ   bankx.vectab + 188    ;
vec.96  equ   bankx.vectab + 190    ;

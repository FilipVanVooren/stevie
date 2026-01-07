* FILE......: rom.vectors.bank6.asm
* Purpose...: Bank 6 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#6'

*--------------------------------------------------------------
* ROM 6: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   data  vdp.dump.patterns        ; Dump character patterns to VDP
vec.2   data  vdp.dump.font            ; Dump font to VDP
vec.3   data  vdp.colors.line          ; Set colors for specified line
vec.4   data  vdp.cursor.tat.fb        ; Set cursor shape (framebuffer)
vec.5   data  vdp.cursor.tat           ; Set cursor shape (cmdb)
vec.6   data  vdp.cursor.tat.cmdb.hide ; Hide CMDB cursor
vec.7   data  cpu.crash                ;
vec.8   data  cpu.crash                ;
vec.9   data  cpu.crash                ;
vec.10  data  cpu.crash                ;
vec.11  data  cpu.crash                ;
vec.12  data  cpu.crash                ;
vec.13  data  cpu.crash                ;
vec.14  data  cpu.crash                ;
vec.15  data  cpu.crash                ;
vec.16  data  cpu.crash                ;
vec.17  data  cpu.crash                ;
vec.18  data  cpu.crash                ;
vec.19  data  cpu.crash                ;
vec.20  data  cpu.crash                ;
vec.21  data  cpu.crash                ;
vec.22  data  cpu.crash                ;
vec.23  data  cpu.crash                ;
vec.24  data  cpu.crash                ;
vec.25  data  cpu.crash                ;
vec.26  data  cpu.crash                ;
vec.27  data  cpu.crash                ;
vec.28  data  cpu.crash                ;
vec.29  data  cpu.crash                ;
vec.30  data  cpu.crash                ;
vec.31  data  cpu.crash                ;
vec.32  data  cpu.crash                ;
*--------------------------------------------------------------
* ROM 6: Vectors 33-64
*--------------------------------------------------------------
vec.33  data  tv.set.font           ; Set current font
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

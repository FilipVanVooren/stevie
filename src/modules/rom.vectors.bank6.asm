* FILE......: rom.vectors.bank6.asm
* Purpose...: Bank 6 vectors for trampoline function

*--------------------------------------------------------------
* ROM 6: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  vdp.dump.patterns     ; Dump character patterns to VDP
vec.2   data  vdp.dump.font         ; Dump font to VDP
vec.3   data  vdp.colors.line       ; Set colors for specified line
vec.4   data  vdp.cursor.tat.fb     ; Set cursor shape (framebuffer)
vec.5   data  vdp.cursor.tat        ; Set cursor shape (cmdb)
vec.6   data  vdp.cursor.tat.cmdb.hide ; Hide CMDB cursor
vec.7   data  tv.set.font           ; Set font
vec.8   data  cpu.crash             ;
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
        stri 'ROM#6'

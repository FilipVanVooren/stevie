* FILE......: rom.vectors.bank4.asm
* Purpose...: Bank 4 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        #string 'ROM#4'

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
        aorg  bankx.vectab

vec.1   data  fb.tab.next           ; Move cursor to next tab position
vec.2   data  fb.ruler.init         ; Setup ruler with tab positions in memory
vec.3   data  fb.colorlines         ; Colorize frame buffer content
vec.4   data  fb.vdpdump            ; Dump framebuffer to VDP SIT
vec.5   data  fb.scan.fname         ; Scan current line for possible filename
vec.6   data  cpu.crash             ;
vec.7   data  cpu.crash             ;
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

* FILE......: rom.vectors.bank4.asm
* Purpose...: Bank 4 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#4'

*--------------------------------------------------------------
* Vector table for trampoline functions
*--------------------------------------------------------------
        aorg  bankx.vectab

vec.1   data  cpu.crash             ;
vec.2   data  fb.ruler.init         ; Setup ruler with tab positions in memory
vec.3   data  fb.colorlines         ; Colorize frame buffer content
vec.4   data  fb.vdpdump            ; Dump frame buffer to VDP SIT
vec.5   data  fb.scan.fname         ; Scan current line for possible filename
vec.6   data  fb.hscroll            ; Horizontal scroll frame buffer window
vec.7   data  fb.restore            ; Restore frame buffer to normal operations
vec.8   data  fb.refresh            ; Refresh frame buffer
vec.9   data  fb.get.nonblank       ; Get column of first non-blank character
vec.10  data  fb.tab.prev           ; Move cursor to previous tab position
vec.11  data  fb.tab.next           ; Move cursor to nexttab position
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

* FILE......: rom.vectors.bank4.asm
* Purpose...: Bank 4 vectors for trampoline function

*--------------------------------------------------------------
* ROM 4: Vectors 1-32 (main table, bankx.vectab)
*--------------------------------------------------------------
        aorg  bankx.vectab
vec.1   data  fb.ruler.init         ; Setup ruler with tab positions in memory
vec.2   data  fb.colorlines         ; Colorize frame buffer content
vec.3   data  fb.vdpdump            ; Dump frame buffer to VDP SIT
vec.4   data  fb.scan.fname         ; Scan current line for possible filename
vec.5   data  fb.hscroll            ; Horizontal scroll frame buffer window
vec.6   data  fb.restore            ; Restore frame buffer to normal operations
vec.7   data  fb.refresh            ; Refresh frame buffer
vec.8   data  fb.get.nonblank       ; Get column of first non-blank character
vec.9   data  fb.tab.prev           ; Move cursor to previous tab position
vec.10  data  fb.tab.next           ; Move cursor to nexttab position
vec.11  data  fb.cursor.up          ; Move cursor up 1 line
vec.12  data  fb.cursor.down        ; Move cursor down 1 line
vec.13  data  fb.cursor.home        ; Move cursor home
vec.14  data  fb.insert.line        ; Insert a new line
vec.15  data  fb.cursor.top         ; Move cursor to top of file
vec.16  data  fb.cursor.topscr      ; Move cursor to top of screen
vec.17  data  fb.cursor.bot         ; Move cursor to bottom of file
vec.18  data  fb.cursor.botscr      ; Move cursor to bottom of screen
vec.19  data  fb.insert.char        ; Insert character
vec.20  data  fb.replace.char       ; Replace character
vec.21  data  fb.goto.prevmatch     ; Goto previous search match
vec.22  data  fb.goto.nextmatch     ; Goto next search match
vec.23  data  pane.topline          ; Draw topline
vec.24  data  pane.botline          ; Draw bottom line
vec.25  data  pane.errline.show     ; Show error line
vec.26  data  pane.errline.hide     ; Hide error line
vec.27  data  pane.errline.drawcolor ; Draw error line
vec.28  data  pane.botline.busy.on  ; Turn on busy indicator on bottom line
vec.29  data  pane.botline.busy.off ; Turn off busy indicator on bottom line
vec.30  data  pane.colorscheme.cycle ; Cycle through color schemes
vec.31  data  pane.colorscheme.load ; Load color scheme
vec.32  data  pane.colorscheme.botline
*--------------------------------------------------------------
* ROM 4: Vectors 33-48 (extension island, bankx.exttab)
*           Referenced from other banks as bankx.exttab+offset
*--------------------------------------------------------------
        aorg  bankx.exttab
extvec.33 data  pane.colorscheme.index ; Get address of color scheme
extvec.34 data  pane.botline.keycolor ; Colorize key markers
extvec.35 data  error.display       ;
extvec.36 data  pane.cmdb.hide      ;
extvec.37 data  pane.filebrowser    ; File browser
extvec.38 data  pane.filebrowser.hilight
extvec.39 data  pane.filebrowser.colbar
extvec.40 data  pane.filebrowser.colbar.remove
extvec.41 data  pane.cmdb.show      ; Show command buffer pane (=dialog)
extvec.42 data  cpu.crash           ;
extvec.43 data  cpu.crash           ;
extvec.44 data  cpu.crash           ;
extvec.45 data  cpu.crash           ;
extvec.46 data  cpu.crash           ;
extvec.47 data  cpu.crash           ;
extvec.48 data  cpu.crash           ;

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        aorg >7fea
        stri 'ROM#4'

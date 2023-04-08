* FILE......: rom.vectors.bank4.asm
* Purpose...: Bank 4 vectors for trampoline function

*--------------------------------------------------------------
* ROM identification string for CPU crash
*--------------------------------------------------------------
cpu.crash.showbank.bankstr:
        stri 'ROM#4'

*--------------------------------------------------------------
* ROM 4: Vectors 1-32
*--------------------------------------------------------------        
        aorg  bankx.vectab
vec.1   data  fb.goto.toprow        ; Refresh FB with top-row and row offset
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
vec.12  data  fb.cursor.up          ; Move cursor up 1 line
vec.13  data  fb.cursor.down        ; Move cursor down 1 line
vec.14  data  fb.cursor.home        ; Move cursor home
vec.15  data  fb.insert.line        ; Insert a new line
vec.16  data  fb.cursor.top         ; Move cursor to top of file
vec.17  data  fb.cursor.topscr      ; Move cursor to top of screen
vec.18  data  fb.cursor.bot         ; Move cursor to bottom of file
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
* ROM 4: Vectors 33-64
*--------------------------------------------------------------
vec.33  data  pane.topline          ; Draw topline
vec.34  data  pane.botline          ; Draw bottom line
vec.35  data  pane.errline.show     ; Show error line
vec.36  data  pane.errline.hide     ; Hide error line
vec.37  data  pane.errline.drawcolor
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
*--------------------------------------------------------------
* ROM 4: Vectors 65-96
*--------------------------------------------------------------
vec.65  data  dialog.help.content   ; Content for Help dialog
vec.66  data  cpu.crash             ;
vec.67  data  cpu.crash             ;
vec.68  data  cpu.crash             ;
vec.69  data  cpu.crash             ;
vec.70  data  cpu.crash             ;
vec.71  data  cpu.crash             ;
vec.72  data  cpu.crash             ;
vec.73  data  cpu.crash             ;
vec.74  data  cpu.crash             ;
vec.75  data  cpu.crash             ;
vec.76  data  cpu.crash             ;
vec.77  data  cpu.crash             ;
vec.78  data  cpu.crash             ;
vec.79  data  cpu.crash             ;
vec.80  data  cpu.crash             ;
vec.81  data  cpu.crash             ;
vec.82  data  cpu.crash             ;
vec.83  data  cpu.crash             ;
vec.84  data  cpu.crash             ;
vec.85  data  cpu.crash             ;
vec.86  data  cpu.crash             ;
vec.87  data  cpu.crash             ;
vec.88  data  cpu.crash             ;
vec.89  data  cpu.crash             ;
vec.90  data  cpu.crash             ;
vec.91  data  cpu.crash             ;
vec.92  data  cpu.crash             ;
vec.93  data  cpu.crash             ;
vec.94  data  cpu.crash             ;
vec.95  data  cpu.crash             ;
vec.96  data  cpu.crash             ;

* FILE......: data.dialogs.asm
* Purpose...: Strings used in dialogs


***************************************************************
*                       Strings
***************************************************************

txt.stevie:
        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor
            text '  Stevie 1.5.9  '
            even
        .endif

        .ifeq vdpmode, 3081         ; F18a 30x80 character cursor
            text ' Stevie 1.5.9   '     
            even
        .endif

        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor
            text ' Stevie 1.5.9   '
            even
        .endif

        .ifeq vdpmode, 2481         ; F18a 24x80 character cursor
            text ' Stevie 1.5.9   '  
            even
        .endif

;--------------------------------------------------------------
; Default key strings used in multiple dialogs
;--------------------------------------------------------------
txt.keys.default1  stri 'F9-Back  F3-Clear  F5-Fastmode IO  FH-Home  FL-EOL'
                   even
txt.keys.default2  stri 'F9-Back  F3-Clear  *F5-Fastmode IO  FH-Home  FL-EOL'
                   even

;--------------------------------------------------------------
; Shared strings used in multiple dialogs
;--------------------------------------------------------------
txt.hint.memstat   stri 'SAMS pages free/total: ..../...    VDP: .. rows, 80 cols          '
                   even

txt.hint.lineterm  stri 'Line termination character (ASCII) = ....'
                   even

;--------------------------------------------------------------
; Dialog "Load file"
;--------------------------------------------------------------
txt.head.load      byte 14,1,1
                   text ' Open file '
                   byte 1
txt.hint.load      stri 'Enter filename of file to open.'

txt.keys.load      equ txt.keys.default1
txt.keys.load2     equ txt.keys.default2

;--------------------------------------------------------------
; Dialog "Save file"
;--------------------------------------------------------------
txt.head.save      byte 14,1,1
                   text ' Save file '
                   byte 1
txt.head.save2     byte 22,1,1
                   text ' Save block to file '
                   byte 1
txt.hint.save      stri 'Enter filename of file to save.'
txt.keys.save1     stri 'F9-Back  F3-Clear  F6-Line term=off  FH-Home  FL-EOL'
txt.keys.save2     stri 'F9-Back  F3-Clear  *F6-Line term=on  FH-Home  FL-EOL'


;--------------------------------------------------------------
; Dialog "Append file"
;--------------------------------------------------------------
txt.head.append    byte 16,1,1
                   text ' Append file '
                   byte 1
txt.hint.append    stri 'Enter filename of file to append at end of current file.'

txt.keys.append    equ txt.keys.default1
txt.keys.append2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Insert file"
;--------------------------------------------------------------
txt.head.insert    byte 24,1,1
                   text ' Insert file at line '
                   byte 1
txt.hint.insert    stri 'Enter filename of file to insert at current line.'

txt.keys.insert    equ txt.keys.default1
txt.keys.insert2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Copy clipboard"
;--------------------------------------------------------------
txt.head.clipboard byte 27,1,1
                   text ' Copy clipboard to line '
                   byte 1
txt.info.clipboard stri 'Clipboard [1-5]?'
txt.hint.clipboard stri 'Press 1 to 5 to copy clipboard, press F7 to configure.'

txt.keys.clipboard  stri 'F9-Back  F5-Fastmode  F7-Configure'
txt.keys.clipboard2 stri 'F9-Back  *F5-Fastmode  F7-Configure'


;--------------------------------------------------------------
; Dialog "Print file"
;--------------------------------------------------------------
txt.head.print     byte 15,1,1
                   text ' Print file '
                   byte 1
txt.head.print2    byte 16,1,1
                   text ' Print block '
                   byte 1
txt.hint.print     stri 'Enter printer device name (PIO, PI.PIO, ...)'
txt.keys.print1    equ  txt.keys.save1
txt.keys.print2    equ  txt.keys.save2


;--------------------------------------------------------------
; Dialog "Goto line"
;--------------------------------------------------------------
txt.head.goto      byte 14,1,1
                   text ' Goto line '
                   byte 1
txt.hint.goto      stri 'Type destination line number (or 0 for EOF) and press ENTER.'
txt.keys.goto      stri 'F9-Back  F3-Clear  ENTER-Goto line'


;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,1
                   text ' Unsaved changes '
                   byte 1
txt.info.unsaved   stri 'Warning! Unsaved changes in file.'
txt.hint.unsaved   stri 'Press F6 or SPACE to proceed. Press ENTER to save file.'
txt.keys.unsaved   stri 'F9-Back  F6/SPACE-Proceed  ENTER-Save'


;--------------------------------------------------------------
; Dialog "Help"
;--------------------------------------------------------------
txt.head.about     byte 9,1,1
                   text ' Help '
                   byte 1

txt.info.about     stri ''
txt.hint.about2    stri 'Licensed under GPLv3 or later. This program comes with ABSOLUTELY NO WARRANTY'
txt.hint.about     stri 'This is free software, you are welcome to redistribute under certain conditions'
txt.keys.about     stri 'F9-Back   ENTER-Close   SPACE-Next Page'

txt.about.build    byte 68
                   text 'Build: '
                   copy "buildstr.asm"
                   text ' - Stevie 1.5.9 - (c)2018-2023 Filip Van Vooren'
                   even


;--------------------------------------------------------------
; Dialog "Main Menu"
;------------------------------------------------------f--------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      stri 'File   Basic   Cartridge   Shortcuts   Options   Help   Quit'
pos.info.menu      byte 0,7,15,27,39,49,56,>ff
txt.hint.menu      stri ''
txt.keys.menu      stri 'F9-Close menu  SPACE-Close menu'

;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,1
                   text ' File '
                   byte 1

txt.info.file      stri 'New   Open   Insert/Append   Save   Print'
pos.info.file      byte 0,6,13,20,29,36,>ff
txt.hint.file      stri ' '
txt.keys.file      stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "Cartridge"
;--------------------------------------------------------------
txt.head.cartridge byte 14,1,1
                   text ' Cartridge '
                   byte 1


txt.info.cartridge stri 'XB-GEM   RXB   FCMD   fbForth'
pos.info.cartridge byte 0,9,16,22,>ff
txt.hint.cartridg2 stri 'Danger zone! FinalGROM with prepared SD card required:'
txt.hint.cartridge stri 'XB29GEM[C,G].bin  RXB[C,G].bin  FCMD[C,G].bin  FBFORTHC.bin'
txt.keys.cartridge stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "TI Basic"
;--------------------------------------------------------------
txt.head.basic     byte 13,1,1
                   text ' TI Basic '
                   byte 1

txt.info.basic     stri 'Session:  1   2   3   4   5  '
pos.info.basic     byte 10,14,18,22,26,>ff
txt.hint.basic2    stri 'Press SPACE to get TI Basic program. Session: Current=',>02,>03,' Visited=',>1d,>1e
txt.hint.basic     stri 'Pick session 1-5. Press F9 (or type END) in TI Basic to return here.'
txt.keys.basic     stri 'F9-Back  F5-AutoUnpack  SPACE=Unpack program'
txt.keys.basic2    stri 'F9-Back  *F5-AutoUnpack'


;--------------------------------------------------------------
; Dialog "Options"
;--------------------------------------------------------------
txt.head.config    byte 12,1,1
                   text ' Options '
                   byte 1

txt.info.config    stri 'Clipboard   Font   Master-Catalog'
pos.info.config    byte 0,12,19,>ff
txt.keys.config    stri 'F9-Back  SPACE-Close menu'

;--------------------------------------------------------------
; Dialog "Configure clipboard"
;--------------------------------------------------------------
txt.head.clipdev   byte 24,1,1
                   text ' Configure clipboard '
                   byte 1
txt.hint.clipdev   stri 'Give device, path and filename prefix of clipboard file.'
txt.keys.clipdev   stri 'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK2.CLIP  ^C=TIPI.CLIP'


;--------------------------------------------------------------
; Dialog "Configure font"
;--------------------------------------------------------------
txt.head.font      byte 19,1,1
                   text ' Configure font '
                   byte 1
txt.info.font      stri 'Font:  1   2   3   4   5'
pos.info.font      byte 7,11,15,19,23,>ff

txt.hint.font      stri 'Pick desired font 1-5. Default font is 1.'
txt.keys.font      stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "Configure Master-Catalog"
;--------------------------------------------------------------
txt.head.cfg.mc    byte 29,1,1
                   text ' Configure Master-Catalog '
                   byte 1
txt.hint.cfg.mc    stri 'Give device, path and filename of Master-Catalog file.'
txt.keys.cfg.mc    stri 'F9-Back  F3-Clear  ^A=DSK1.MASTCAT  ^B=DSK6.MASTCAT    ^C=TIPI.MASTCAT'


;--------------------------------------------------------------
; Dialog "Shortcuts"
;--------------------------------------------------------------
txt.head.shortcuts byte 14,1,1
                   text ' Shortcuts '
                   byte 1

txt.info.shortcuts stri 'Catalog   Colors   Ruler   Autoinsert   M1/M2/Goto   Master-Catalog'
                   even
pos.info.shortcuts byte 0,11,19,27,41,44,46,53,>ff
                   even
txt.hint.shortcuts stri ' '
                   even
txt.keys.shortcuts stri 'F9-Back  SPACE-Close menu'
                   even

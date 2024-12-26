* FILE......: data.dialogs.asm
* Purpose...: Strings used in dialogs


***************************************************************
*                       Strings
***************************************************************

txt.stevie:
        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor
            text '  Stevie 1.6.7   '
            even
        .endif

        .ifeq vdpmode, 3081         ; F18a 30x80 character cursor
            text '  Stevie 1.6.7   '     
            even
        .endif

        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor
            text '  Stevie 1.6.7   '
            even
        .endif

        .ifeq vdpmode, 2481         ; F18a 24x80 character cursor
            text '  Stevie 1.6.7   '  
            even
        .endif

;--------------------------------------------------------------
; Default key strings used in multiple dialogs
;--------------------------------------------------------------
txt.keys.default1  stri 'F9-Back  F3-Clear  F5-FMIO  FH-Home  FL-EOL  ^1-9=CAT DSK1-9  SPACE-UpDir'
                   even
txt.keys.default2  stri 'F9-Back  F3-Clear  *F5-FMIO  FH-Home  FL-EOL  ^1-9=CAT DSK1-9  SPACE-UpDir'
                   even

;--------------------------------------------------------------
; Shared strings used in multiple dialogs
;--------------------------------------------------------------
txt.hint.memstat   stri 'SAMS free/total: .../...'
                   even

txt.hint.lineterm  stri 'Line termination character (ASCII) = ....'
                   even

txt.hint.filepicker:
                   stri 'FE/X-up/down  ^E/X-prev/next page  ^S/D-prev/next column'
                   even

;--------------------------------------------------------------
; Dialog "Load file"
;--------------------------------------------------------------
txt.head.load      byte 14,1,1
                   text ' Open file '
                   byte 1
txt.hint.load      equ  txt.hint.filepicker
txt.hint.load2     stri 'Enter filename or pick file from catalog.'

txt.keys.load      equ txt.keys.default1
txt.keys.load2     equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "run file"
;--------------------------------------------------------------
txt.head.run       byte 28,1,1
                   text ' Run program image (EA5) '
                   byte 1
txt.hint.run       equ  txt.hint.filepicker
txt.hint.run2      stri 'Enter filename or pick file from catalog.'

txt.keys.run       equ txt.keys.default1
txt.keys.run2      equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Save file"
;--------------------------------------------------------------
txt.head.save      byte 14,1,1
                   text ' Save file '
                   byte 1
txt.head.save2     byte 22,1,1
                   text ' Save block to file '
                   byte 1
txt.hint.save      stri 'Enter filename.'
txt.keys.save1     stri 'F9-Back  F3-Clear  F6-Line term=off  FH-Home  FL-EOL'
txt.keys.save2     stri 'F9-Back  F3-Clear  *F6-Line term=on  FH-Home  FL-EOL'


;--------------------------------------------------------------
; Dialog "Append file"
;--------------------------------------------------------------
txt.head.append    byte 16,1,1
                   text ' Append file '
                   byte 1
txt.hint.append    equ  txt.hint.filepicker                   
txt.hint.append2   equ  txt.hint.load2

txt.keys.append    equ txt.keys.default1
txt.keys.append2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Insert file"
;--------------------------------------------------------------
txt.head.insert    byte 24,1,1
                   text ' Insert file at line '
                   byte 1
txt.hint.insert    equ  txt.hint.filepicker
txt.hint.insert2   equ  txt.hint.load2

txt.keys.insert    equ txt.keys.default1
txt.keys.insert2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Catalog"
;--------------------------------------------------------------
txt.head.dir       byte 12,1,1
                   text ' Catalog '
                   byte 1
txt.hint.dir       equ  txt.hint.filepicker
txt.hint.dir2      stri 'Enter device name and path. Last character must be "."'

txt.keys.dir       equ txt.keys.default1
txt.keys.dir2      equ txt.keys.default2

;--------------------------------------------------------------
; Dialog "Copy clipboard"
;--------------------------------------------------------------
txt.head.clipboard byte 27,1,1
                   text ' Copy clipboard to line '
                   byte 1
txt.info.clipboard stri 'Clipboard [1-5]?'
txt.hint.clipboard stri 'Press 1 to 5 to copy clipboard, press F7 to configure.'

txt.keys.clipboard  stri 'F9-Back  F5-FMIO  F7-Configure'
txt.keys.clipboard2 stri 'F9-Back  *F5-FMIO  F7-Configure'


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

txt.about.build    byte 69
                   text 'Build: '
                   copy "buildstr.asm"
                   text ' - Stevie 1.6.7  - (c)2018-2024 Filip Van Vooren'
                   even


;--------------------------------------------------------------
; Dialog "Main Menu"
;--------------------------------------------------------------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      stri 'File   Basic   Cartridge   Shortcuts   Options   Help   Quit'
pos.info.menu      byte 0,7,15,27,39,49,56,>ff
txt.hint.menu      stri ''
txt.keys.menu      stri 'F9-Close menu  SPACE-Close menu'
txt.keys.menu2     stri 'F9-Close menu  SPACE-Close menu'

;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,1
                   text ' File '
                   byte 1

txt.info.file      stri 'New   Open   Run   Save   Insert   Append   Catalog   Print'
pos.info.file      byte 0,6,13,19,26,35,44,54,>ff
txt.hint.file      stri ' '
txt.keys.file      stri 'F9-Back  SPACE-Close menu'

;--------------------------------------------------------------
; Dialog "Cartridge"
;--------------------------------------------------------------
txt.head.cartridge byte 14,1,1
                   text ' Cartridge '
                   byte 1


txt.info.cartridge stri 'XB-GEM   FCMD   fbForth'
pos.info.cartridge byte 0,9,16,>ff
txt.hint.cartridg2 stri 'Danger zone! FinalGROM with prepared SD card required:'
txt.hint.cartridge stri 'XB29GEM[C,G].bin  FCMD[C,G].bin  FBFORTHC.bin'
txt.keys.cartridge stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "TI Basic"
;--------------------------------------------------------------
txt.head.basic     byte 13,1,1
                   text ' TI Basic '
                   byte 1

txt.info.basic     stri 'Session:  1   2   3  '
pos.info.basic     byte 10,14,18,>ff
txt.hint.basic2    stri 'Press SPACE to retrieve TI Basic program. Session: Current=',>02,>03,' Visited=',>1d,>1e
txt.hint.basic     stri 'Pick session 1-3. Press F9 (or type END) in TI Basic to return here.'
txt.keys.basic     stri 'F9-Back  F5-AutoUnpack  SPACE-Unpack program'
txt.keys.basic2    stri 'F9-Back  *F5-AutoUnpack'

;--------------------------------------------------------------
; Dialog "Options"
;--------------------------------------------------------------
txt.head.config    byte 12,1,1
                   text ' Options '
                   byte 1

txt.info.config    stri 'Autoinsert   Clipboard   Font'
pos.info.config    byte 0,13,25,>ff
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
; Dialog "Shortcuts"
;--------------------------------------------------------------
txt.head.shortcuts byte 14,1,1
                   text ' Shortcuts '
                   byte 1

txt.info.shortcuts stri 'Colors   Find   Goto   Ruler   M1-M2'
                   even
pos.info.shortcuts byte 0,9,16,23,31,34,>ff
                   even
txt.hint.shortcuts stri ' '
                   even
txt.keys.shortcuts stri 'F9-Back  SPACE-Close menu'
                   even

;--------------------------------------------------------------
; Dialog "Find"
;--------------------------------------------------------------
txt.head.find      byte 9,1,1
                   text ' Find '
                   byte 1
txt.hint.find      stri 'Press F5 to toggle case-sensitive search on/off.'
                   even                   
txt.hint.find2     stri 'Enter search string.'
                   even
txt.keys.find      stri 'F9-Back  F3-Clear  FH-Home  FL-EOL'
                   even

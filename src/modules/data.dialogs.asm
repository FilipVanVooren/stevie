* FILE......: data.dialogs.asm
* Purpose...: Strings used in dialogs


***************************************************************
*                       Strings
***************************************************************

txt.stevie:
        .ifeq vdpmode, 3080         ; F18a 30x80 sprite cursor
            text '  Stevie 1.7.4   '
            even
        .endif

        .ifeq vdpmode, 3081         ; F18a 30x80 character cursor
            text '  Stevie 1.7.4   '     
            even
        .endif

        .ifeq vdpmode, 2480         ; F18a 24x80 sprite cursor
            text '  Stevie 1.7.4   '
            even
        .endif

        .ifeq vdpmode, 2481         ; F18a 24x80 character cursor
            text '  Stevie 1.7.4   '  
            even
        .endif

;--------------------------------------------------------------
; Default key strings used in multiple dialogs
;--------------------------------------------------------------
txt.keys.default1  stri 'F9-Back  F3-Clear  F5-FMIO  FH-Home  FL-EOL  ^1-9=DSK1-9'
                   even
txt.keys.default2  stri 'F9-Back  F3-Clear  *F5-FMIO  FH-Home  FL-EOL  ^1-9=DSK1-9'
                   even

;--------------------------------------------------------------
; Shared strings used in multiple dialogs
;--------------------------------------------------------------
txt.hint.memstat   stri 'SAMS free/total: .../...'
                   even

txt.hint.lineterm  stri 'Line termination character (ASCII) = ....'
                   even

txt.hint.filepicker:
                   stri 'FE/X-up/down  ^E/X-prev/next page  ^S/D-prev/next column  SPACE-UpDir'
                   even

;--------------------------------------------------------------
; Dialog "Load file"
;--------------------------------------------------------------
txt.head.load      byte 13,4,1
                   text ' Open file '
txt.hint.load      equ  txt.hint.filepicker
txt.hint.load2     stri 'Enter filename or pick file from catalog.'
txt.keys.load      equ txt.keys.default1
txt.keys.load2     equ txt.keys.default2
                   even

;--------------------------------------------------------------
; Dialog "Run program image (EA5)"
;--------------------------------------------------------------
txt.head.run       byte 27,4,1
                   text ' Run program image (EA5) '
txt.info.run       stri 'Feature not yet available.'
txt.hint.run       equ  txt.hint.filepicker
txt.hint.run2      stri 'Enter filename or pick file from catalog.'
txt.keys.run       equ txt.keys.default1
txt.keys.run2      equ txt.keys.default2
                   even

;--------------------------------------------------------------
; Dialog "Save file"
;--------------------------------------------------------------
txt.head.save      byte 13,4,1
                   text ' Save file '
txt.head.save2     byte 21,4,1
                   text ' Save block to file '
txt.hint.save      stri 'Enter filename.'
txt.keys.save1     stri 'F9-Back  F3-Clear  F6-Line term=off  FH-Home  FL-EOL'
txt.keys.save2     stri 'F9-Back  F3-Clear  *F6-Line term=on  FH-Home  FL-EOL'
                   even

;--------------------------------------------------------------
; Dialog "Append file"
;--------------------------------------------------------------
txt.head.append    byte 15,4,1
                   text ' Append file '
txt.hint.append    equ  txt.hint.filepicker                   
txt.hint.append2   equ  txt.hint.load2
txt.keys.append    equ txt.keys.default1
txt.keys.append2   equ txt.keys.default2
                   even

;--------------------------------------------------------------
; Dialog "Insert file"
;--------------------------------------------------------------
txt.head.insert    byte 23,4,1
                   text ' Insert file at line '
txt.hint.insert    equ  txt.hint.filepicker
txt.hint.insert2   equ  txt.hint.load2
txt.keys.insert    equ txt.keys.default1
txt.keys.insert2   equ txt.keys.default2
                   even

;--------------------------------------------------------------
; Dialog "Catalog"
;--------------------------------------------------------------
txt.head.dir       byte 11,4,1
                   text ' Catalog '
txt.hint.dir       equ  txt.hint.filepicker
txt.hint.dir2      stri 'Enter device name and path. Last character must be "."'
txt.keys.dir       equ txt.keys.default1
txt.keys.dir2      equ txt.keys.default2
                   even

;--------------------------------------------------------------
; Dialog "Copy clipboard"
;--------------------------------------------------------------
txt.head.clipboard  byte 26,4,1
                    text ' Copy clipboard to line '
txt.info.clipboard  stri 'Clipboard [1-3]?'
txt.hint.clipboard  stri 'Press 1 to 3 to copy clipboard file, F7 to configure.'
txt.keys.clipboard  stri 'F9-Back  F7-Configure'
                    even

;--------------------------------------------------------------
; Dialog "Print file"
;--------------------------------------------------------------
txt.head.print     byte 14,4,1
                   text ' Print file '
txt.head.print2    byte 15,4,1
                   text ' Print block '
txt.hint.print     stri 'Enter printer device name (PIO, PI.PIO, ...)'
txt.keys.print1    equ  txt.keys.save1
txt.keys.print2    equ  txt.keys.save2
                   even

;--------------------------------------------------------------
; Dialog "Goto line"
;--------------------------------------------------------------
txt.head.goto      byte 13,4,1
                   text ' Goto line '
txt.hint.goto      stri 'Type destination line number (or 0 for EOF) and press ENTER.'
txt.keys.goto      stri 'F9-Back  F3-Clear  ENTER-Goto line'
                   even

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 19,4,1
                   text ' Unsaved changes '
txt.info.unsaved   stri 'Warning! Unsaved changes in file.'
txt.hint.unsaved   stri 'Press F6 or SPACE to proceed. Press ENTER to save file.'
txt.keys.unsaved   stri 'F9-Back  F6/SPACE-Proceed  ENTER-Save'
                   even

;--------------------------------------------------------------
; Dialog "Help"
;--------------------------------------------------------------
txt.head.about     byte 8,4,1
                   text ' Help '
txt.info.about     stri ''
txt.hint.about2    stri 'Report bugs and feature requests at:'
txt.hint.about     stri 'https://github.com/FilipVanVooren/stevie'
txt.keys.about     stri 'F9-Back   ENTER-Close   SPACE-Next Page'

txt.about.build    byte 69
                   text 'Build: '
                   copy "buildstr.asm"
                   text ' - Stevie 1.7.4  - (c)2018-2025 Filip Van Vooren'
                   even

;--------------------------------------------------------------
; Dialog "Main Menu"
;--------------------------------------------------------------
txt.head.menu      byte 13,4,1
                   text ' Main Menu '
txt.info.menu      stri 'File   Basic   Cartridge   Shortcuts   Options   Help   Quit'
pos.info.menu      byte 0,7,15,27,39,49,56,>ff
txt.hint.menu      stri ''
txt.keys.menu      stri 'F9-Close menu  SPACE-Close menu'
txt.keys.menu2     stri 'F9-Close menu  SPACE-Close menu'
                   even

;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 8,4,1
                   text ' File '
txt.info.file      stri 'New   Open   Run   Save   Insert   Append   Catalog   Print'
pos.info.file      byte 0,6,13,19,26,35,44,54,>ff
txt.hint.file      stri ' '
txt.keys.file      stri 'F9-Back  SPACE-Close menu'
                   even

;--------------------------------------------------------------
; Dialog "Cartridge Type"
;--------------------------------------------------------------
txt.head.cart.type  byte 13,4,1
                    text ' Cartridge '
txt.info.cart.type  stri 'FinalGROM 99'
pos.info.cart.type  byte 0,>ff
txt.hint.cart.type2 stri 'Select currently inserted cartridge.'
txt.hint.cart.type  stri ''
txt.keys.cart.type  stri 'F9-Back  SPACE-Close menu'
                    even

;--------------------------------------------------------------
; Dialog "FinalGROM 99"
;--------------------------------------------------------------
txt.head.cart.fg99   byte 16,4,1
                     text ' FinalGROM 99 '
txt.hint.cart.fg99   stri 'Enter filename without .bin extension (max. 8 char).'
txt.hint.cart.fg992  stri 'Load cartridge from SD card. Image must be in same directory as Stevie.'
txt.keys.cart.fg99   stri 'F9-Back  F3-Clear  FH-Home  FL-EOL'
                     even

;--------------------------------------------------------------
; Dialog "TI Basic"
;--------------------------------------------------------------
txt.head.basic     byte 12,4,1
                   text ' TI Basic '
txt.info.basic     stri 'Session:  1   2   3  '
pos.info.basic     byte 10,14,18,>ff
txt.hint.basic2    stri 'Pick session 1-3. Press F9 (or type END) in TI Basic to return here.'
txt.hint.basic     stri 'Press SPACE to retrieve TI Basic program.'
txt.keys.basic     stri 'F9-Back  F5-AutoUnpack  SPACE-Unpack program'
txt.keys.basic2    stri 'F9-Back  *F5-AutoUnpack'
                   even

;--------------------------------------------------------------
; Dialog "Options"
;--------------------------------------------------------------
txt.head.config    byte 11,4,1
                   text ' Options '
txt.info.config    stri 'Autoinsert   Clipboard   Font'
pos.info.config    byte 0,13,25,>ff
txt.keys.config    stri 'F9-Back  SPACE-Close menu'
                   even

;--------------------------------------------------------------
; Dialog "Configure clipboard"
;--------------------------------------------------------------
txt.head.clipdev   byte 23,4,1
                   text ' Configure clipboard '
txt.hint.clipdev   stri 'Give device, path and filename prefix of clipboard file.'
txt.keys.clipdev   stri 'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=TIPI.CLIP'
                   even

;--------------------------------------------------------------
; Dialog "Configure font"
;--------------------------------------------------------------
txt.head.font      byte 18,4,1
                   text ' Configure font '
txt.info.font      stri 'Font:  1   2   3   4   5'
pos.info.font      byte 7,11,15,19,23,>ff

txt.hint.font      stri 'Pick desired font 1-5. Default font is 1.'
txt.keys.font      stri 'F9-Back  SPACE-Close menu'
                   even

;--------------------------------------------------------------
; Dialog "Shortcuts"
;--------------------------------------------------------------
txt.head.shortcuts byte 13,4,1
                   text ' Shortcuts '
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
txt.head.find      byte 8,4,1
                   text ' Find '
txt.hint.find      stri ''
                   even                   
txt.hint.find2     stri 'Enter search string.'
                   even
txt.keys.find      stri 'F9-Back  F3-Clear  FH-Home  FL-EOL'
                   even

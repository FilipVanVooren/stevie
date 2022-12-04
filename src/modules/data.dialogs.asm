* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

txt.stevie:
        .ifeq full_f18a_support,1
            text '  Stevie 1.3L  '
            even
        .else
            text ' Stevie 1.3L-24'
            even
        .endif

txt.keys.default1  stri 'F9-Back  F3-Clear  F5-Fastmode'
                   even
txt.keys.default2  stri 'F9-Back  F3-Clear  *F5-Fastmode'
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
txt.keys.save      stri 'F9-Back  F3-Clear'


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
txt.keys.print     stri 'F9-Back  F3-Clear'

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

txt.about.build    byte 72
                   text 'Build: '
                   copy "buildstr.asm"
                   text ' / Stevie copyright (c)2018-2022  Filip Van Vooren'
                   even

;--------------------------------------------------------------
; Dialog "Main Menu"
;--------------------------------------------------------------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      stri 'File   Cartridge   Configure   Shortcuts   Help   Quit'
pos.info.menu      byte 0,7,20,31,43,50,>ff
txt.hint.menu      stri 'Press F9 or SPACE to close the main menu.'
txt.keys.menu      stri 'F9/SPACE-Close menu'

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

txt.info.cartridge stri 'TI Basic'
pos.info.cartridge byte 3,>ff
txt.hint.cartridge stri 'Select cartridge to run.'
txt.keys.cartridge stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "TI Basic"
;--------------------------------------------------------------
txt.head.basic     byte 13,1,1
                   text ' TI Basic '
                   byte 1

txt.info.basic     stri 'Session:  1   2   3   4   5  '
pos.info.basic     byte 10,14,18,22,26,>ff
txt.hint.basic     stri 'Pick session 1-5. Press F9 in TI Basic to return to Stevie.'
txt.keys.basic     stri 'F9-Back  F5-AutoMode  SPACE-Close menu'
txt.keys.basic2    stri 'F9-Back  *F5-AutoMode  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "Configure"
;--------------------------------------------------------------
txt.head.config    byte 14,1,1
                   text ' Configure '
                   byte 1

txt.info.config    stri 'Clipboard'
pos.info.config    byte 0,>ff
txt.keys.config    stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "Configure clipboard"
;--------------------------------------------------------------
txt.head.clipdev   byte 24,1,1
                   text ' Configure clipboard '
                   byte 1
txt.hint.clipdev   stri 'Give device and filename prefix of clipboard file.'
txt.keys.clipdev   stri 'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK2.CLIP  ^C=TIPI.CLIP'


;--------------------------------------------------------------
; Dialog "Configure editor"
;--------------------------------------------------------------
txt.head.editor    byte 21,1,1
                   text ' Configure editor '
                   byte 1
txt.info.editor    stri 'AutoInsert: Yes/No'
pos.info.editor    byte 12,16,>ff

txt.hint.editor    stri 'Select editor preferences.'
txt.keys.editor    stri 'F9-Back  SPACE-Close menu'


;--------------------------------------------------------------
; Dialog "Shortcuts"
;--------------------------------------------------------------
txt.head.shortcuts byte 14,1,1
                   text ' Shortcuts '
                   byte 1

txt.info.shortcuts stri 'Colors   Ruler   Autoinsert   M1/M2'
                   even
pos.info.shortcuts byte 0,9,17,31,34,>ff
                   even
txt.hint.shortcuts stri ' '
                   even
txt.keys.shortcuts stri 'F9-Back  SPACE-Close menu'
                   even

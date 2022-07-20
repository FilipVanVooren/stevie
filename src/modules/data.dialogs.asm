* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

txt.stevie:
        .ifeq full_f18a_support,1
            text ' Stevie 1.3H-30'
            even
        .else
            text ' Stevie 1.3H-24'
            even
        .endif

txt.keys.default1  stri 'F9-Back  F3-Clear  F5-Fastmode'
txt.keys.default2  stri 'F9-Back  F3-Clear  *F5-Fastmode'

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
txt.hint.append    stri 'Eter filename of file to append at end of current file.'

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
txt.hint.about     stri 'Licensed under GPLv3. Press F9 or ENTER to return to editor.'
txt.keys.about     stri 'F9-Back  SPACE-Next Page  ENTER-Back'

txt.about.build    byte 76
                   text 'Build: '
                   copy "buildstr.asm"
                   text ' / 2018-2022 Filip Van Vooren'
                   text ' / retroclouds on Atariage'
                   even


;--------------------------------------------------------------
; Dialog "Main Menu"
;--------------------------------------------------------------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      stri 'File   Cartridge   Configure   Shortcuts   Help   Quit'
pos.info.menu      byte 0,7,20,31,43,50,>ff
txt.hint.menu      stri ' '
txt.keys.menu      stri 'F9-Back'


;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,1
                   text ' File '
                   byte 1

txt.info.file      stri 'New   Open   Insert/Append   Save   Print'
pos.info.file      byte 0,6,13,20,29,36,>ff
txt.hint.file      stri ' '
txt.keys.file      stri 'F9-Back'


;--------------------------------------------------------------
; Dialog "Cartridge"
;--------------------------------------------------------------
txt.head.cartridge byte 14,1,1
                   text ' Cartridge '
                   byte 1

txt.info.cartridge stri 'TI Basic'
pos.info.cartridge byte 3,>ff
txt.hint.cartridge stri 'Select cartridge to run.'
txt.keys.cartridge stri 'F9-Back'


;--------------------------------------------------------------
; Dialog "TI Basic"
;--------------------------------------------------------------
txt.head.basic     byte 13,1,1
                   text ' TI Basic '
                   byte 1

txt.info.basic     stri 'Session:  1   2   3   4   5  '
pos.info.basic     byte 10,14,18,22,26,>ff
txt.hint.basic     stri 'Pick session 1-5. Press F9 in TI BASIC for returning to Stevie.'
txt.keys.basic     stri 'F9-Back  F5-AutoMode'
txt.keys.basic2    stri 'F9-Back  *F5-AutoMode'


;--------------------------------------------------------------
; Dialog "Configure"
;--------------------------------------------------------------
txt.head.config    byte 14,1,1
                   text ' Configure '
                   byte 1

txt.info.config    stri 'Clipboard'
pos.info.config    byte 0,>ff
txt.hint.config    stri ' '
txt.keys.config    stri 'F9-Back'


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
txt.keys.editor    stri 'F9-Back'


;--------------------------------------------------------------
; Dialog "Shortcuts"
;--------------------------------------------------------------
txt.head.shortcuts byte 14,1,1
                   text ' Shortcuts '
                   byte 1

txt.info.shortcuts stri 'Colors   Ruler   Autoinsert   M1/M2'
pos.info.shortcuts byte 0,9,17,31,34,>ff
txt.hint.shortcuts stri 'Select a shortcut or press F9 to return.'
txt.keys.shortcuts stri 'F9-Back'

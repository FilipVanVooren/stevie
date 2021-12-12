* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

txt.stevie         text ' Stevie 1.2K '
                   even
txt.keys.default1  #string 'F9-Back  F3-Clear  F5-Fastmode'
txt.keys.default2  #string 'F9-Back  F3-Clear  *F5-Fastmode'

;--------------------------------------------------------------
; Dialog "Load file"
;--------------------------------------------------------------
txt.head.load      byte 14,1,1
                   text ' Open file '
                   byte 1
txt.hint.load      #string 'Give filename of file to open.'

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
txt.hint.save      #string 'Give filename of file to save.'
txt.keys.save      #string 'F9-Back  F3-Clear'


;--------------------------------------------------------------
; Dialog "Append file"
;--------------------------------------------------------------
txt.head.append    byte 16,1,1
                   text ' Append file '
                   byte 1
txt.hint.append    #string 'Give filename of file to append at the end of the current file'

txt.keys.append    equ txt.keys.default1
txt.keys.append2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Insert file"
;--------------------------------------------------------------
txt.head.insert    byte 24,1,1
                   text ' Insert file at line '
                   byte 1
txt.hint.insert    #string 'Give filename of file to insert.'

txt.keys.insert    equ txt.keys.default1
txt.keys.insert2   equ txt.keys.default2


;--------------------------------------------------------------
; Dialog "Configure clipboard device"
;--------------------------------------------------------------
txt.head.clipdev   byte 31,1,1
                   text ' Configure clipboard device '
                   byte 1
txt.hint.clipdev   #string 'Give device and filename prefix of clipboard.'
txt.keys.clipdev   #string 'F9-Back  F3-Clear  ^A=DSK1.CLIP  ^B=DSK8.CLIP  ^C=TIPI.STEVIE.CLIP'


;--------------------------------------------------------------
; Dialog "Copy clipboard"
;--------------------------------------------------------------
txt.head.clipboard byte 27,1,1
                   text ' Copy clipboard to line '
                   byte 1
txt.info.clipboard #string 'Clipboard [1-5]?'
txt.hint.clipboard #string 'Press 1 to 5 to copy clipboard, press F7 to configure clipboard device.'

txt.keys.clipboard  #string 'F9-Back  F5-Fastmode  F7-Configure'
txt.keys.clipboard2 #string 'F9-Back  *F5-Fastmode  F7-Configure'


;--------------------------------------------------------------
; Dialog "Print file"
;--------------------------------------------------------------
txt.head.print     byte 15,1,1
                   text ' Print file '
                   byte 1
txt.head.print2    byte 16,1,1
                   text ' Print block '
                   byte 1
txt.hint.print     #string 'Give printer device name (PIO, PI.PIO, ...)'
txt.keys.print     #string 'F9-Back  F3-Clear'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,1
                   text ' Unsaved changes '
                   byte 1
txt.info.unsaved   #string 'Warning! Unsaved changes in file.'
txt.hint.unsaved   #string 'Press F6 or SPACE to proceed. Press ENTER to save file.'
txt.keys.unsaved   #string 'F9-Back  F6/SPACE-Proceed  ENTER-Save'

;--------------------------------------------------------------
; Dialog "Help"
;--------------------------------------------------------------
txt.head.about     byte 9,1,1
                   text ' Help '
                   byte 1

txt.info.about     #string ''
txt.hint.about     #string 'Press F9 or ENTER to return to editor.'
txt.keys.about     #string 'F9-Back  ENTER-Back'
txt.about.build    #string 'Build: %%build_date%% / 2018-2021 Filip Van Vooren / retroclouds on Atariage'


;--------------------------------------------------------------
; Dialog "Main Menu"
;--------------------------------------------------------------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      #string 'File   Basic   Help   Quit'
pos.info.menu      byte 0,7,15,22,>ff
txt.hint.menu      #string ' '
txt.keys.menu      #string 'F9-Back'


;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,1
                   text ' File '
                   byte 1

txt.info.file      #string 'New   Open   Save   Print   Configure'
pos.info.file      byte 0,6,13,20,28,>ff
txt.hint.file      #string ' '
txt.keys.file      #string 'F9-Back'


;--------------------------------------------------------------
; Dialog "Basic"
;--------------------------------------------------------------
txt.head.basic     byte 14,1,1
                   text ' Run basic '
                   byte 1

txt.info.basic     #string 'TI Basic   TI Extended Basic'
pos.info.basic     byte 3,14,>ff
txt.hint.basic     #string ' '
txt.keys.basic     #string 'F9-Back'


;--------------------------------------------------------------
; Dialog "Configure"
;--------------------------------------------------------------
txt.head.config    byte 14,1,1
                   text ' Configure '
                   byte 1

txt.info.config    #string 'Clipboard'
pos.info.config    byte 0,>ff
txt.hint.config    #string ' '
txt.keys.config    #string 'F9-Back'
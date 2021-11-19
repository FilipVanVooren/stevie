* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

txt.stevie         text ' Stevie 1.2F '

;--------------------------------------------------------------
; Dialog Load file
;--------------------------------------------------------------
txt.head.load      byte 14,1,1
                   text ' Open file '
                   byte 1
txt.hint.load      #string 'Give filename of file to open.'

txt.keys.load      #string 'F9-Back  F3-Clear  F5-Fastmode'
txt.keys.load2     #string 'F9-Back  F3-Clear  *F5-Fastmode'

;--------------------------------------------------------------
; Dialog Save file
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
; Insert file
;--------------------------------------------------------------
txt.head.insert    byte 24,1,1
                   text ' Insert file at line '
                   byte 1
txt.hint.insert    #string 'Give filename of file to insert.'

txt.keys.insert    #string 'F9-Back  F3-Clear  F5-Fastmode'
txt.keys.insert2   #string 'F9-Back  F3-Clear  *F5-Fastmode'


;--------------------------------------------------------------
; Insert snippet from clipbaord
;--------------------------------------------------------------
txt.head.clipboard byte 42,1,1
                   text ' Insert snippet from clipboard at line '
                   byte 1
txt.info.clipboard #string 'Clipboard?'
txt.hint.clipboard #string 'Press 1 to 5 for inserting snippet from corresponding clipboard.'

txt.keys.clipboard  #string 'F9-Back  F5-Fastmode  1..5-Clipboard'
txt.keys.clipboard2 #string 'F9-Back  *F5-Fastmode  1..5-Clipboard'


;--------------------------------------------------------------
; Dialog Print file
;--------------------------------------------------------------
txt.head.print     byte 15,1,1
                   text ' Print file '
                   byte 1
txt.head.print2    byte 16,1,1
                   text ' Print block '
                   byte 1
txt.hint.print     #string 'Give printer device name (PIO, TIPI.PIO, ...)'
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
; Dialog "Menu"
;--------------------------------------------------------------
txt.head.menu      byte 14,1,1
                   text ' Main Menu '
                   byte 1

txt.info.menu      #string 'File   Basic   Help   Options   Quit'
pos.info.menu      byte 0,7,15,22,32,>ff
txt.hint.menu      #string ' '
txt.keys.menu      #string 'F9-Back'


;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,1
                   text ' File '
                   byte 1

txt.info.file      #string 'New   Open   Insert   Clipboard   Save   Print'
pos.info.file      byte 0,6,13,22,34,41,>ff
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

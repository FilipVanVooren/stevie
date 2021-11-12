* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

txt.stevie         #string 'Stevie 1.2E'

;--------------------------------------------------------------
; Dialog Load file
;--------------------------------------------------------------
txt.head.load      byte 14,1,1
                   text ' Open file '
                   byte 1
txt.hint.load      #string 'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'

txt.keys.load      #string 'F9-Back  F3-Clear  F5-Fastmode  FH-Home  FL-End'
txt.keys.load2     #string 'F9-Back  F3-Clear  *F5-Fastmode  FH-Home  FL-End'

;--------------------------------------------------------------
; Dialog Save file
;--------------------------------------------------------------
txt.head.save      byte 14,1,1
                   text ' Save file '
                   byte 1
txt.head.save2     byte 22,1,1
                   text ' Save block to file '
                   byte 1
txt.hint.save      #string ' '
txt.keys.save      #string 'F9-Back  F3-Clear  FH-Home  FL-End'


;--------------------------------------------------------------
; Insert file
;--------------------------------------------------------------
txt.head.insert    byte 24,1,1
                   text ' Insert file at line '
                   byte 1
txt.hint.insert    #string 'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'

txt.keys.insert    #string 'F9-Back  F3-Clear  F5-Fastmode  FH-Home  FL-End'
txt.keys.insert2   #string 'F9-Back  F3-Clear  *F5-Fastmode  FH-Home  FL-End'


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
txt.keys.print     #string 'F9-Back  F3-Clear  FH-Home  FL-End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,1
                   text ' Unsaved changes '
                   byte 1
txt.info.unsaved   #string 'Warning! Unsaved changes in file.'
txt.hint.unsaved   #string 'Press F6 to proceed or ENTER to save file.'
txt.keys.unsaved   #string 'F9-Back  F6-Proceed'

;--------------------------------------------------------------
; Dialog "Help"
;--------------------------------------------------------------
txt.head.about     byte 9,1,1
                   text ' Help '
                   byte 1

txt.info.about     #string ''
txt.hint.about     #string 'Press F9 to return to editor.'
txt.keys.about     byte 27
                   text 'F9-Back  '
                   byte 14,15
                   text '-Alpha Lock down'

txt.about.build    #string 'Build: %%build_date%% / 2018-2021 Filip Van Vooren / retroclouds on Atariage'


;--------------------------------------------------------------
; Dialog "Menu"
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

txt.info.file      #string 'New   Open / Insert   Save   Print'
pos.info.file      byte 0,6,13,22,29,>ff
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

* FILE......: data.strings.bank3.asm
* Purpose...: Strings used in Stevie bank 3


***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Dialog Load DV 80 file
;--------------------------------------------------------------
txt.head.load      byte 19,1,3
                   text ' Open DV80 file '
                   byte 2
txt.hint.load      #string 'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'

txt.keys.load      byte 49
                   text 'F9=Back  F3=Clear  F5=Fastmode  F-H=Home  F-L=End'

txt.keys.load2     byte 50
                   text 'F9=Back  F3=Clear  *F5=Fastmode  F-H=Home  F-L=End'

;--------------------------------------------------------------
; Dialog Save DV 80 file
;--------------------------------------------------------------
txt.head.save      byte 19,1,3
                   text ' Save DV80 file '
                   byte 2
txt.head.save2     byte 35,1,3,32
                   text 'Save marked block to DV80 file '
                   byte 2
txt.hint.save      #string ' '

txt.keys.save      byte 36
                   text 'F9=Back  F3=Clear  F-H=Home  F-L=End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,3
                   text ' Unsaved changes '
                   byte 2
txt.info.unsaved   #string 'Warning! Unsaved changes in file.'
txt.hint.unsaved   #string 'Press F6 to proceed or ENTER to save file.'
txt.keys.unsaved   #string 'Confirm: F9=Back  F6=Proceed  ENTER=Save'

;--------------------------------------------------------------
; Dialog "About"
;--------------------------------------------------------------
txt.head.about     byte 10,1,3
                   text ' About '
                   byte 2

txt.info.about     #string 
txt.hint.about     #string 'Press F9 to return to editor.'
txt.keys.about     byte 33
                   text 'Help: F9=Back  '
                   byte 14,15
                   text '=Alpha Lock down'

txt.stevie         #string 'STEVIE 1.1U'
txt.about.build    #string 'Build: %%build_date%% / 2018-2021 Filip Van Vooren / retroclouds on Atariage'


;--------------------------------------------------------------
; Dialog "Menu"
;--------------------------------------------------------------
txt.head.menu      byte 16,1,3
                   text ' Stevie 1.1U '
                   byte 2

txt.info.menu      #string 'File / Basic / Help / Quit'
pos.info.menu      byte 0,7,15,22,>ff
txt.hint.menu      #string 'Press F,B,H,Q or F9 to return to editor.'
txt.keys.menu      #string 'F9=Back'


;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,3
                   text ' File '
                   byte 2

txt.info.file      #string 'New / Open / Save'
pos.info.file      byte 0,6,13,>ff
txt.hint.file      #string 'Press N,O,S or F9 to return to editor.'
txt.keys.file      #string 'F9=Back'

;--------------------------------------------------------------
; Dialog "Basic"
;--------------------------------------------------------------
txt.head.basic     byte 14,1,3
                   text ' Run basic '
                   byte 2

txt.info.basic     #string 'TI Basic / TI Extended Basic'
pos.info.basic     byte 3,14,>ff
txt.hint.basic     #string 'Press B,E for running basic dialect or F9 to return to editor.'
txt.keys.basic     #string 'F9=Back'

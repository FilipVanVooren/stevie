* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for about pane
;--------------------------------------------------------------
txt.stevie         #string 'STEVIE 1.1K'
txt.about.build    #string 'Build: %%build_date%% / 2018-2021 Filip Van Vooren / retroclouds on Atariage'

txt.delim          #string ','
txt.bottom         #string '  BOT'
txt.ovrwrite       #string 'OVR'
txt.insert         #string 'INS'
txt.star           #string '*'
txt.loading        #string 'Loading...'
txt.saving         #string 'Saving....'
txt.block.del      #string 'Deleting block....'
txt.block.copy     #string 'Copying block....'
txt.block.move     #string 'Moving block....'
txt.block.save     #string 'Saving block to DV80 file....'
txt.fastmode       #string 'Fastmode'
txt.kb             #string 'kb'
txt.lines          #string 'Lines'
txt.newfile        #string '[New file]'
txt.filetype.dv80  #string 'DV80'
txt.m1             #string 'M1='
txt.m2             #string 'M2='
txt.keys.default   #string 'Editor: ^Help, ^File, ^Quit'
txt.keys.block     #string 'Block: F9=Back, ^Del, ^Copy, ^Move, ^Goto M1, ^Save'
txt.ruler          text    '.........'
                   byte    18
                   text    '.........'
                   byte    19
                   text    '.........'
                   byte    20
                   text    '.........'
                   byte    21
                   text    '.........'
                   byte    22                   
                   text    '.........'                   
                   byte    23                   
                   text    '.........'
                   byte    24                   
                   text    '.........'
                   byte    25
                   even

txt.alpha.down     data >020e,>0f00
txt.vertline       data >0110

txt.ws1            #string ' '
txt.ws2            #string '  '
txt.ws3            #string '   '
txt.ws4            #string '    '
txt.ws5            #string '     '
txt.filetype.none  equ txt.ws4


;--------------------------------------------------------------
; Dialog Load DV 80 file
;--------------------------------------------------------------
txt.head.load      byte 19,1,3,32
                   text 'Open DV80 file '
                   byte 2
txt.hint.load      #string 'Select Fastmode for file buffer in CPU RAM (HRD/HDX/IDE only)'

txt.keys.load      byte 60
                   text 'File'
                   byte 27
                   text 'Open: F9=Back, F3=Clear, F5=Fastmode, F-H=Home, F-L=End '

txt.keys.load2     byte 61
                   text 'File'
                   byte 27
                   text 'Open: F9=Back, F3=Clear, *F5=Fastmode, F-H=Home, F-L=End '

;--------------------------------------------------------------
; Dialog Save DV 80 file
;--------------------------------------------------------------
txt.head.save      byte 19,1,3,32
                   text 'Save DV80 file '
                   byte 2
txt.head.save2     byte 35,1,3,32
                   text 'Save marked block to DV80 file '
                   byte 2
txt.hint.save      #string ' '

txt.keys.save      byte 47
                   text 'File'
                   byte 27                   
                   text 'Save: F9=Back, F3=Clear, F-H=Home, F-L=End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,3,32
                   text 'Unsaved changes '
                   byte 2
txt.info.unsaved   #string 'Warning! Unsaved changes in file.'
txt.hint.unsaved   #string 'Press F6 to proceed or ENTER to save file.'
txt.keys.unsaved   #string 'Confirm: F9=Back, F6=Proceed, ENTER=Save file'

;--------------------------------------------------------------
; Dialog "About"
;--------------------------------------------------------------
txt.head.about     byte 10,1,3,32
                   text 'About '
                   byte 2

txt.info.about     #string 
txt.hint.about     #string 'Press F9 or ENTER to return to editor.'
txt.keys.about     byte 45
                   text 'Help: F9=Back, ENTER=Back, '
                   byte 14,15
                   text '=Alpha Lock down'


;--------------------------------------------------------------
; Dialog "File"
;--------------------------------------------------------------
txt.head.file      byte 9,1,3,32
                   text 'File '
                   byte 2

txt.info.file      #string '[N]ew file, [O]pen file, [S]ave file'
txt.hint.file      #string 'Press N,O,S or ENTER to return to editor.'
txt.keys.file      #string 'File: F9=Back, ENTER=Back'


;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     #string 'I/O error. Failed loading file: '
txt.ioerr.save     #string 'I/O error. Failed saving file:  '
txt.memfull.load   #string 'Index memory full. Could not fully load file into editor buffer.'
txt.io.nofile      #string 'I/O error. No filename specified.'
txt.block.inside   #string 'Error. Copy/Move target must be outside block M1-M2.'

;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.prompt    #string '>'
txt.colorscheme    #string 'Color scheme:'
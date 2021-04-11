* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for welcome pane
;--------------------------------------------------------------
txt.about.build    #string 'Build: %%build_date%% / 2018-2021 Filip Van Vooren / retroclouds on Atariage'
;--------------------------------------------------------------
; Strings for status line pane
;--------------------------------------------------------------
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
txt.bufnum         #string '#1 '
txt.newfile        #string '[New file]'
txt.filetype.dv80  #string 'DV80'
txt.m1             #string 'M1='
txt.m2             #string 'M2='
txt.stevie         #string  'STEVIE 1.1E  '
txt.keys.default   #string 'F0=Help  ^Open  ^Save'
txt.keys.block     #string '^Del  ^Copy  ^Move  ^Goto M1  ^Reset  ^Save'
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


txt.alpha.up       data >010f
txt.alpha.down     data >010e
txt.vertline       data >0110

txt.clear          #string '    '
txt.filetype.none  equ txt.clear


;--------------------------------------------------------------
; Dialog Load DV 80 file
;--------------------------------------------------------------
txt.head.load      byte 19,1,3,32
                   text 'Open DV80 file '
                   byte 2
txt.hint.load      #string 'Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
txt.keys.load      #string 'F9=Back    F3=Clear    F5=Fastmode    F-H=Home    F-L=End'
txt.keys.load2     #string 'F9=Back    F3=Clear   *F5=Fastmode    F-H=Home    F-L=End'

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
txt.keys.save      #string 'F9=Back    F3=Clear    F-H=Home    F-L=End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   byte 20,1,3,32
                   text 'Unsaved changes '
                   byte 2
txt.info.unsaved   #string 'You are about to lose changes to the current file!'
txt.hint.unsaved   #string 'Press F6 to proceed without saving or ENTER to save file.'
txt.keys.unsaved   #string 'F9=Back    F6=Proceed    ENTER=Save file'

;--------------------------------------------------------------
; Dialog "About"
;--------------------------------------------------------------
txt.head.about     byte 10,1,3,32
                   text 'About '
                   byte 2

txt.info.about     #string 
txt.hint.about     #string 'Press F9 or ENTER to return to editor.'
txt.keys.about     byte 61
                   text 'F9=Back    ENTER=Back   ALPHA LOCK Up= '
                   byte 15
                   text '   ALPHA LOCK Down= '
                   byte 14

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
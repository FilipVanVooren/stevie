* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for welcome pane
;--------------------------------------------------------------
txt.about.program  #string 'Stevie v1.0 (beta 2)'
                   even
txt.about.author   #string '2018-2021  Filip Van Vooren'
txt.about.website  #string 'https://stevie.oratronik.de'
txt.about.build    #string 'Build: %%build_date%%'

;--------------------------------------------------------------
; Strings for status line pane
;--------------------------------------------------------------
txt.delim          #string ','
txt.marker         #string '*EOF*'
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

txt.keys.block     byte    43
                   text    '^Del  ^Copy  ^Move  ^Goto M1  ^Reset  ^Save'

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

txt.info.about     #string 'A programming editor for the expanded Texas Instruments TI-99/4a Home Computer.'
txt.hint.about     #string 'Press F9 or ENTER to return to editor.'
txt.keys.about     byte 51
                   text 'F9=Back    ENTER=Back   ALPHA UP= '
                   byte 15
                   text '   ALPHA DOWN= '
                   byte 14

;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     #string 'I/O error. Failed loading file: '
txt.ioerr.save     #string 'I/O error. Failed saving file: '
txt.memfull.load   #string 'Index memory full. Could not fully load file into editor buffer.'
txt.io.nofile      #string 'I/O error. No filename specified.'
txt.block.inside   #string 'Error. Copy/Move target must be outside block M1-M2.'


;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.title     #string 'Command buffer'
txt.cmdb.prompt    #string '>'

txt.stevie         byte    12
                   byte    10
                   text    'Stevie v1.0 (beta 2)'
                   byte    11
                   even            

txt.colorscheme    #string 'Color scheme:'
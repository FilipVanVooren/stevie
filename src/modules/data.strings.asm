* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

;--------------------------------------------------------------
; Strings for welcome pane
;--------------------------------------------------------------
txt.wp.program     #string 'Stevie v0.1b'
txt.wp.purpose     #string 'Programming Editor for the TI-99/4a'
txt.wp.author      #string '2018-2020 by Filip Van Vooren'
txt.wp.website     #string 'https://stevie.oratronik.de'
txt.wp.build       #string 'Build: %%build_date%%'

txt.wp.msg1        #string 'FCTN-7 (F7)   Help, shortcuts, about'
txt.wp.msg2        #string 'FCTN-9 (F9)   Toggle edit/cmd mode'
txt.wp.msg3        #string 'FCTN-+        Quit Stevie'
txt.wp.msg4        #string 'CTRL-L (^L)   Load DV80 file'
txt.wp.msg5        #string 'CTRL-K (^K)   Save DV80 file'
txt.wp.msg6        #string 'CTRL-Z (^Z)   Cycle colors'

txt.wp.msg7        byte    56,13
                   text    ' ALPHA LOCK up     '
                   byte    12
                   text    ' ALPHA LOCK down   '
                   text    '  * Text changed'

txt.wp.msg8        #string 'Press ENTER to return to editor'



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
txt.saving         #string 'Saving...'
txt.fastmode       #string 'Fastmode'
txt.kb             #string 'kb'
txt.lines          #string 'Lines'
txt.bufnum         #string '#1 '
txt.newfile        #string '[New file]'
txt.filetype.dv80  #string 'DV80'
txt.filetype.none  #string '    '

txt.alpha.up       data >010d
txt.alpha.down     data >010c
txt.vertline       data >010e


;--------------------------------------------------------------
; Dialog Load DV 80 file
;--------------------------------------------------------------
txt.head.load      #string 'Load DV80 file '
txt.hint.load      #string 'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer (HRD/HDX/IDE).'
txt.keys.load      #string 'F9=Back    F3=Clear    F5=Fastmode    ^A=Home    ^F=End'
txt.keys.load2     #string 'F9=Back    F3=Clear   *F5=Fastmode    ^A=Home    ^F=End'

;--------------------------------------------------------------
; Dialog Save DV 80 file
;--------------------------------------------------------------
txt.head.save      #string 'Save DV80 file '
txt.hint.save      #string 'HINT: Fastmode uses CPU RAM instead of VDP RAM for file buffer.'
txt.keys.save      #string 'F9=Back    F3=Clear    ^A=Home    ^F=End'

;--------------------------------------------------------------
; Dialog "Unsaved changes"
;--------------------------------------------------------------
txt.head.unsaved   #string 'Unsaved changes '
txt.hint.unsaved   #string 'HINT: Press ENTER to save file or F6 to proceed without saving.'
txt.keys.unsaved   #string 'F9=Back    F6=Proceed    ENTER=Save file'
txt.warn.unsaved   #string '* You are about to lose changes to the current file!'

;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     #string 'I/O error. Failed loading file: '
txt.ioerr.save     #string 'I/O error. Failed saving file: '
txt.io.nofile      #string 'I/O error. No filename specified.'


;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.title     #string 'Command buffer'
txt.cmdb.prompt    #string '>'


txt.stevie         byte    12
                   byte    10
                   text    'stevie v1.00'
                   byte    11
                   even

txt.colorscheme    #string 'Color scheme: '


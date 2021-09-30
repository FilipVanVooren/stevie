* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

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
txt.keys.default   #string 'F9-Menu'
txt.keys.block     #string 'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Goto-M1'
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
txt.keymarker      byte 1,28

txt.ws1            #string ' '
txt.ws2            #string '  '
txt.ws3            #string '   '
txt.ws4            #string '    '
txt.ws5            #string '     '
txt.filetype.none  equ txt.ws4


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
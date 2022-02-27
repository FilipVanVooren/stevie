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
txt.printing       #string 'Printing file.....'
txt.block.del      #string 'Deleting block....'
txt.block.copy     #string 'Copying block....'
txt.block.move     #string 'Moving block....'
txt.block.save     #string 'Saving block to file....'
txt.block.clip     #string 'Copying to clipboard....'
txt.block.print    #string 'Printing block....'
txt.clearmem       #string 'Clearing memory....'
txt.done.load      #string 'Load completed'
txt.done.insert    #string 'Insert completed'
txt.done.append    #string 'Append completed'
txt.done.save      #string 'Save completed'
txt.done.copy      #string 'Copy completed'
txt.done.print     #string 'Print completed'
txt.done.delete    #string 'Delete completed'
txt.done.clipboard #string 'Clipboard saved'
txt.done.clipdev   #string 'Clipboard set'
txt.fastmode       #string 'Fastmode'
txt.uncrunching    #string 'Expanding TI Basic line....'
txt.kb             #string 'kb'
txt.lines          #string 'Lines'
txt.newfile        #string '[New file]'
txt.tib1           #string '[TI Basic #1]'
txt.tib2           #string '[TI Basic #2]'
txt.tib3           #string '[TI Basic #3]'
txt.tib4           #string '[TI Basic #4]'
txt.tib5           #string '[TI Basic #5]'
txt.filetype.dv80  #string 'DV80'
txt.m1             #string 'M1='
txt.m2             #string 'M2='
txt.keys.default   #string 'F9-Menu  ^H-Help'
txt.keys.defaultb  #string 'F9-Menu  ^H-Help  F0-TI Basic'
txt.keys.block     #string 'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
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
txt.ioerr.load     #string 'Failed loading file: '
txt.ioerr.save     #string 'Failed saving file: '
txt.ioerr.print    #string 'Failed printing to device: '
txt.io.nofile      #string 'No filename specified.'
txt.memfull.load   #string 'Index full. File too large for editor buffer.'
txt.block.inside   #string 'Copy/Move target must be outside M1-M2 range.'

;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.prompt    #string '>'
txt.colorscheme    #string 'Color scheme:'
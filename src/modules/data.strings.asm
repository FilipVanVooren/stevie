* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

txt.delim          stri ','
txt.bottom         stri '  BOT'
txt.ovrwrite       stri 'OVR '
txt.insert         stri 'INS '
txt.autoinsert     stri 'INS+'
txt.star           stri '*'
txt.loading        stri 'Loading...'
txt.saving         stri 'Saving....'
txt.printing       stri 'Printing file.....'
txt.block.del      stri 'Deleting block....'
txt.block.copy     stri 'Copying block....'
txt.block.move     stri 'Moving block....'
txt.block.save     stri 'Saving block to file....'
txt.block.clip     stri 'Copying to clipboard....'
txt.block.print    stri 'Printing block....'
txt.clearmem       stri 'Clearing memory....'
txt.done.load      stri 'Load completed'
txt.done.insert    stri 'Insert completed'
txt.done.append    stri 'Append completed'
txt.done.save      stri 'Save completed'
txt.done.copy      stri 'Copy completed'
txt.done.print     stri 'Print completed'
txt.done.delete    stri 'Delete completed'
txt.done.clipboard stri 'Clipboard saved'
txt.done.clipdev   stri 'Clipboard set'
txt.autoins.on     stri 'Autoinsert: on'
txt.autoins.off    stri 'Autoinsert: off'
txt.fastmode       stri 'Fastmode'
txt.uncrunching    stri 'Expanding TI Basic line....'
txt.kb             stri 'kb'
txt.lines          stri 'Lines'
txt.newfile        stri '[New file]'
txt.tib1           stri '[TI Basic #1]'
txt.tib2           stri '[TI Basic #2]'
txt.tib3           stri '[TI Basic #3]'
txt.tib4           stri '[TI Basic #4]'
txt.tib5           stri '[TI Basic #5]'
txt.filetype.dv80  stri 'DV80'
txt.m1             stri 'M1='
txt.m2             stri 'M2='
txt.keys.default   stri 'F9-Menu  ^H-Help'
txt.keys.defaultb  stri 'F9-Menu  ^H-Help  F0-Basic#'
txt.keys.block     stri 'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
txt.keys.basic1    stri 'F9-Back  F5-AutoMode  SPACE-Uncrunch program'
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

txt.ws1            stri ' '
txt.ws2            stri '  '
txt.ws3            stri '   '
txt.ws4            stri '    '
txt.ws5            stri '     '
txt.filetype.none  equ txt.ws4


;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     stri 'Failed loading file: '
txt.ioerr.save     stri 'Failed saving file: '
txt.ioerr.print    stri 'Failed printing to device: '
txt.io.nofile      stri 'No filename specified.'
txt.memfull.load   stri 'Index full. File too large for editor buffer.'
txt.block.inside   stri 'Copy/Move target must be outside M1-M2 range.'

;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.prompt    stri '>'
txt.colorscheme    stri 'Color scheme:'

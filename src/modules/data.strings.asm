* FILE......: data.strings.asm
* Purpose...: Stevie Editor - data segment (strings)

***************************************************************
*                       Strings
***************************************************************

txt.delim          stri ','
                   even
txt.bottom         stri '  BOT'
                   even
txt.ovrwrite       stri 'OVR '
                   even
txt.insert         stri 'INS '
                   even
txt.autoinsert     stri 'INS+'
                   even
txt.star           stri '*'
                   even
txt.loading        stri 'Loading...'
                   even
txt.saving         stri 'Saving....'
                   even
txt.printing       stri 'Printing file.....'
                   even
txt.block.del      stri 'Deleting block....'
                   even
txt.block.copy     stri 'Copying block....'
                   even
txt.block.move     stri 'Moving block....'
                   even
txt.block.save     stri 'Saving block to file....'
                   even
txt.block.clip     stri 'Copying to clipboard....'
                   even
txt.block.print    stri 'Printing block....'
                   even
txt.clearmem       stri 'Clearing memory....'
                   even
txt.done.load      stri 'Load completed'
                   even
txt.done.insert    stri 'Insert completed'
                   even
txt.done.append    stri 'Append completed'
                   even
txt.done.save      stri 'Save completed'
                   even
txt.done.copy      stri 'Copy completed'
                   even
txt.done.print     stri 'Print completed'
                   even
txt.done.delete    stri 'Delete completed'
                   even
txt.done.clipboard stri 'Clipboard saved'
                   even
txt.done.clipdev   stri 'Clipboard set'
                   even
txt.autoins.on     stri 'Autoinsert: on'
                   even
txt.autoins.off    stri 'Autoinsert: off'
                   even
txt.fastmode       stri 'Fastmode'
                   even
txt.uncrunching    stri 'Expanding TI Basic line....'
                   even
txt.kb             stri 'kb'
                   even
txt.lines          stri 'Lines'
                   even
txt.newfile        stri '[New file]'
                   even
txt.tib1           stri '[TI Basic #1]'
                   even
txt.tib2           stri '[TI Basic #2]'
                   even
txt.tib3           stri '[TI Basic #3]'
                   even
txt.tib4           stri '[TI Basic #4]'
                   even
txt.tib5           stri '[TI Basic #5]'
                   even
txt.filetype.dv80  stri 'DV80'
                   even
txt.m1             stri 'M1='
                   even
txt.m2             stri 'M2='
                   even
txt.keys.default   stri 'F9-Menu  ^H-Help'
                   even
txt.keys.defaultb  stri 'F9-Menu  ^H-Help  F0-Basic#'
                   even
txt.keys.block     stri 'F9-Back  ^Copy  ^Move  ^Del  ^Save  ^Print  ^[1-5]Clip'
                   even
txt.keys.basic1    stri 'F9-Back  ENTER-Back  F5-AutoMode  SPACE-Uncrunch program'
                   even
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
                   even
txt.ws2            stri '  '
                   even
txt.ws3            stri '   '
                   even
txt.ws4            stri '    '
                   even
txt.ws5            stri '     '
                   even
txt.filetype.none  equ txt.ws4


;--------------------------------------------------------------
; Strings for error line pane
;--------------------------------------------------------------
txt.ioerr.load     stri 'Failed loading file: '
                   even
txt.ioerr.save     stri 'Failed saving file: '
                   even
txt.ioerr.print    stri 'Failed printing to device: '
                   even
txt.io.nofile      stri 'No filename specified.'
                   even
txt.memfull.load   stri 'Index full. File too large for editor buffer.'
                   even
txt.block.inside   stri 'Copy/Move target must be outside M1-M2 range.'
                   even

;--------------------------------------------------------------
; Strings for command buffer
;--------------------------------------------------------------
txt.cmdb.prompt    stri '>'
                   even
txt.colorscheme    stri 'Color scheme:'
                   even

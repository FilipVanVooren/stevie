* FILE......: data.strings.asm
* Purpose...: RAM shared strings

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
txt.labelscan      stri 'Scanning labels in source code...'
                   even
txt.block.del      stri 'Deleting block....'
                   even
txt.block.copy     stri 'Copying block....'
                   even
txt.block.move     stri 'Moving block....'
                   even
txt.block.save     stri 'Saving block....'
                   even
txt.block.clip     stri 'Copying to clipboard....'
                   even
txt.block.print    stri 'Printing block....'
                   even
txt.clearmem       stri 'Clearing memory....'
                   even
txt.readdir        stri 'Reading catalog....'                   
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
txt.fastmode       stri 'Fastmode IO'
                   even
txt.nodisk         stri 'No Device/Disk/Path'
                   even
txt.uncrunching    stri 'Uncrunching TI Basic line....'
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
txt.keys.default   stri 'F9-Menu  ^H-Help  ^U-Shortcuts'
                   even
txt.keys.defaultb  stri 'F9-Menu  ^H-Help  ^U-Shortcuts  F0-Basic#'
                   even
txt.keys.block     stri 'F9-Exit  ^Copy ^Move ^Del ^Save ^Print ^[1-3]Clipbrd'
                   even
txt.keys.basic1    stri 'F9-Back  F5-AutoUnpack  SPACE-Unpack program'
                   even
txt.alpha.down     data >020e,>0f00
txt.vertline       data >0110
txt.keymarker      byte 1,28
                   even
txt.ws1            stri ' '
                   even
txt.ws2            stri '  '
                   even
txt.ws4            stri '    '
                   even
txt.filetype.none  equ txt.ws4

txt.msg.tibasic    stri 'TI Basic mode active.'
                   even
            
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
txt.memfull.load   stri 'Index full. File too large.'
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

; BE CAREFUL HERE. RAM MIGHT BE FULL AND STRINGS CHOPPED OFF. KEEP THEM SHORT.

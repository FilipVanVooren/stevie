
dialog.help.maxpage:
        data 1               ; Index of highest page in help system

txt.dialog.help.maxpage:
        stri '/2'            ; Display "x/2" in help system
        even

dialog.help.data.pages:
        ;------------------------------------------------------
        ; Page index table
        ;------------------------------------------------------
        data  dialog.help.data.page1,58,37,>202a        
        data  dialog.help.data.page2,6,37,>0000


dialog.help.data.page1:
        ;------------------------------------------------------
        ; Left column
        ;------------------------------------------------------
        byte 38
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text ' Cursor '
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'fctn s/d/e/x  Left, Right, Up, Down'
        stri 'fctn h/l      Home, End of line'
        stri 'fctn j/k      Previous word, Next word'
        stri 'fctn 4   ^x   Page down'
        stri 'fctn 5        move view window right'
        stri 'ctrl 5   ^5   move view window left'
        stri 'fctn 6   ^e   Page up'
        stri 'fctn 7        Next tab'        
        stri 'ctrl 7   ^7   Prev tab'        
        stri 'fctn v        Screen top'
        stri 'ctrl v   ^v   File top'
        stri 'fctn b        Screen bottom'
        stri 'ctrl b   ^b   File bottom'
        stri 'ctrl g   ^g   Goto line'        
        stri 'ctrl ,   ^,   Goto previous match'
        stri 'ctrl .   ^.   Goto next match'
        stri ' '
        stri ' '                
        byte 38
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text ' File '
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'ctrl a   ^a   Append file'
        stri 'ctrl i   ^i   Insert file at line'
        stri 'ctrl c   ^c   Copy clipboard to line'
        stri 'ctrl o   ^o   Open file'
        stri 'ctrl p   ^p   Print file'
        stri 'ctrl r   ^r   Run program image (EA5)'        
        stri 'ctrl s   ^s   Save file'
        stri ' '
        stri ' '
        stri 'Licensed under GPLv3 or later. This program comes with ABSOLUTELY NO WARRANTY'
        stri 'This is free software, you are welcome to redistribute under certain conditions'
        byte 36
        byte 1,1,1,1,1,1,1,1,1,1,1,1
        text ' Modifiers '
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'fctn 1        Delete character'
        stri 'fctn 2        Insert character'
        stri 'fctn 3        Delete line'
        stri 'ctrl l   ^l   Delete end of line'
        stri 'fctn 8        Insert line'
        stri 'fctn .        Insert/Overwrite'
        stri 'ctrl c   ^c   Copy clipboard'
        stri 'ctrl u   ^u   Unlock editor'
        stri ' '
        byte 36
        byte 1,1,1,1,1,1
        text ' File picker (catalog) '
        byte 1,1,1,1,1,1,1
        stri 'ctrl e   ^e   Previous page'
        stri 'ctrl x   ^x   Next page'
        stri 'ctrl s   ^s   Previous column'        
        stri 'ctrl d   ^d   Next column'
        stri 'fctn e/x      Up/Down'
        stri 'ctrl 0-9 ^0-9 Catalog DSK1-DSK9'
        stri 'SPACE         Parent directory'
        stri ' '
        byte 36
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1
        text ' Block Mode '
        byte 1,1,1,1,1,1,1,1,1,1,1
        stri 'ctrl SPACE    Set M1/M2 marker'
        stri 'ctrl d   ^d   Delete block'
        stri 'ctrl c   ^c   Copy block'
        stri 'ctrl g   ^g   Goto line'
        stri 'ctrl m   ^m   Move block'
        stri 'ctrl s   ^s   Save block to file'
        stri 'ctrl ^1..^3   Copy to clipboard 1-3'





dialog.help.data.page2:
        ;------------------------------------------------------
        ; Left column
        ;------------------------------------------------------
        byte 38
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text ' Others '
        byte 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'fctn +   ^q   Quit'
        stri 'fctn 0        TI Basic session'
        stri 'ctrl 0   ^0   TI Basic submenu'
        stri 'ctrl u   ^u   Shortcuts menu'
        stri 'ctrl z   ^z   Cycle color schemes'

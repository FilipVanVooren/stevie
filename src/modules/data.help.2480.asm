dialog.help.data.pages:
        data  dialog.help.data.page1,31,37,>0f2a
        data  dialog.help.data.page2,31,37,>0f2a
        data  dialog.help.data.page3,18,37,>0f2a


dialog.help.data.page1:
        ;------------------------------------------------------
        ; Left column
        ;------------------------------------------------------
        stri ' '
        stri ' '
        byte    38
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Cursor '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn s/d/e/x  Left, Right, Up, Down'
        stri 'Fctn h/l      Home, End of line'
        stri 'Fctn j/k      Previous word, Next word'
        stri 'Fctn 4   ^x   Page down'
        stri 'Fctn 5        move view window right'
        stri 'Ctrl 5   ^5   move view window left'
        stri 'Fctn 6   ^e   Page up'
        stri 'Fctn 7        Next tab'        
        stri 'Ctrl 7   ^7   Prev tab'        
        stri 'Fctn v        Screen top'
        stri 'Ctrl v   ^v   File top'
        stri 'Fctn b        Screen bottom'
        stri ' '        
        ;------------------------------------------------------
        ; Right column
        ;------------------------------------------------------
        stri '                            Page 1/3'
        stri ' '
        stri 'Ctrl b   ^b   File bottom'
        stri 'Ctrl g   ^g   Goto line'        
        stri 'Ctrl ,   ^,   Goto previous match'
        stri 'Ctrl .   ^.   Goto next match'
        stri ' ' 
        byte    36
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' File '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Ctrl a   ^a   Append file'
        stri 'Ctrl i   ^i   Insert file at line'
        stri 'Ctrl c   ^c   Copy clipboard to line'
        stri 'Ctrl o   ^o   Open file'
        stri 'Ctrl p   ^p   Print file'
        stri 'Ctrl r   ^r   Run program image (EA5)'        
        stri 'Ctrl s   ^s   Save file'        

dialog.help.data.page2:
        ;------------------------------------------------------
        ; Left column
        ;------------------------------------------------------
        stri ' '
        stri ' '
        byte    35
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Modifiers '
        byte    1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn 1        Delete character'
        stri 'Fctn 2        Insert character'
        stri 'Fctn 3        Delete line'
        stri 'Ctrl l   ^l   Delete end of line'
        stri 'Fctn 8        Insert line'
        stri 'Fctn .        Insert/Overwrite'
        stri 'Ctrl c   ^c   Copy clipboard'
        stri 'Ctrl u   ^u   Unlock editor'
        stri ' '
        byte    35
        byte    1,1,1,1,1,1
        text    ' File picker (catalog) '
        byte    1,1,1,1,1,1
        stri 'Ctrl e   ^e   Previous page'
        stri 'Ctrl x   ^x   Next page'
        stri ' ' 
        ;------------------------------------------------------
        ; Right column
        ;------------------------------------------------------
        stri '                            Page 2/3'
        stri ' '
        stri 'Ctrl s   ^s   Previous column'        
        stri 'Ctrl d   ^d   Next column'
        stri 'Fctn e/x      Up/Down'
        stri 'Ctrl 0-9 ^0-9 Catalog DSK1-DSK9'
        stri 'SPACE         Parent directory'
        stri ' '
        byte    36
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Block Mode '
        byte    1,1,1,1,1,1,1,1,1,1,1
        stri 'Ctrl SPACE    Set M1/M2 marker'
        stri 'Ctrl d   ^d   Delete block'
        stri 'Ctrl c   ^c   Copy block'
        stri 'Ctrl g   ^g   Goto line'
        stri 'Ctrl m   ^m   Move block'
        stri 'Ctrl s   ^s   Save block to file'
        stri ' '


dialog.help.data.page3:        
        ;------------------------------------------------------
        ; Left column
        ;------------------------------------------------------
        stri ' '
        stri ' '
        byte    36
        byte    1,1,1,1,1,1,1,1,1
        text    ' Block Mode (rest) '
        byte    1,1,1,1,1,1,1,1
        stri 'Ctrl ^1..^3   Copy to clipboard 1-3'
        stri ' '
        byte    35
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Others '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn +   ^q   Quit'
        stri 'Fctn 0        TI Basic session'
        stri 'Ctrl 0   ^0   TI Basic submenu'
        stri 'Ctrl u   ^u   Shortcuts menu'
        stri 'Ctrl z   ^z   Cycle color schemes'
        stri ' '
        stri ' '
        stri ' '
        stri ' '
        stri ' '                        
        ;------------------------------------------------------
        ; Right column
        ;------------------------------------------------------
        stri '                            Page 3/3'
        stri ' '

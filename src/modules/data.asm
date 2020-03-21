* FILE......: data.asm
* Purpose...: TiVi Editor - data segment (constants, strings, ...)

***************************************************************
*                      Constants
********|*****|*********************|**************************
romsat:
        data  >0303,>000f           ; Cursor YX, initial shape and colour

cursors:
        data >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
        data >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
        data >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode

lines:
        data >0000,>ff00,>00ff,>0080 ; Double line top + ruler
        data >0080,>0000,>ff00,>ff00 ; Ruler + double line bottom        
        data >0000,>0000,>ff00,>ff00 ; Double line bottom, without ruler        
        data >0000,>c0c0,>c0c0,>0080 ; Double line top left corner        
        data >0000,>0f0f,>0f0f,>0000 ; Double line top right corner


tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
        data  >f404                 ; White      | Dark blue  | Dark blue
        data  >f101                 ; White      | Black      | Black
        data  >1707                 ; Black      | Cyan       | Cyan
        data  >1f0f                 ; Black      | White      | White


***************************************************************
*                       Strings
***************************************************************
txt.delim          #string ','
txt.marker         #string '*EOF*'
txt.bottom         #string '  BOT'
txt.ovrwrite       #string 'OVR'
txt.insert         #string 'INS'
txt.star           #string '*'
txt.loading        #string 'Loading...'
txt.kb             #string 'kb'
txt.rle            #string 'RLE'
txt.lines          #string 'Lines'
txt.ioerr          #string '> I/O error occured. Could not load file:'
txt.bufnum         #string '#1'
txt.newfile        #string '[New file]'
txt.cmdb           #string 'Command Buffer'
txt.filetype.dv80  #string 'DIS/VAR80 '
txt.filetype.none  #string '          '

txt.tivi     byte    24
             byte    4
             text    'TiVi beta %%build_date%%'
             byte    5
end          data    $ 


fdname0      #string 'DSK1.INVADERS'
fdname1      #string 'DSK1.SPEECHDOCS'
fdname2      #string 'DSK1.XBEADOC'
fdname3      #string 'DSK3.XBEADOC'
fdname4      #string 'DSK3.C99MAN1'
fdname5      #string 'DSK3.C99MAN2'
fdname6      #string 'DSK3.C99MAN3'
fdname7      #string 'DSK3.C99SPECS'
fdname8      #string 'DSK3.RANDOM#C'
fdname9      #string 'DSK1.INVADERS'

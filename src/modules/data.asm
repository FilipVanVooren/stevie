* FILE......: data.asm
* Purpose...: TiVi Editor - data segment (constants, strings, ...)

***************************************************************
*                      Constants
***************************************************************
romsat:
        data >0303,>0008              ; Cursor YX, initial shape and colour

cursors:
        data >0000,>0000,>0000,>001c  ; Cursor 1 - Insert mode
        data >1010,>1010,>1010,>1000  ; Cursor 2 - Insert mode
        data >1c1c,>1c1c,>1c1c,>1c00  ; Cursor 3 - Overwrite mode

lines:
        data >0080,>0000,>ff00,>ff00  ; Ruler and double line        
        data >0000,>0000,>ff00,>ff00  ; Double line                

***************************************************************
*                       Strings
***************************************************************
txt_delim    #string ','
txt_marker   #string '*EOF*'
txt_bottom   #string '  BOT'
txt_ovrwrite #string 'OVR'
txt_insert   #string 'INS'
txt_star     #string '*'
txt_loading  #string 'Loading...'
txt_kb       #string 'kb'
txt_rle      #string 'RLE'
txt_lines    #string 'Lines'
txt_ioerr    #string '* I/O error occured. Could not load file.'
txt_bufnum   #string '#1'
txt_newfile  #string '[New file]'
txt_tivi     #string 'TiVi beta %%build_date%%'
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

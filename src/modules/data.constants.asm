* FILE......: data.constants.asm
* Purpose...: TiVi Editor - data segment (constants)

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
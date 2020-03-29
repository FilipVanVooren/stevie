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

patterns:
        data >0000,>ff00,>00ff,>0080 ; 01. Double line top + ruler
        data >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom                        
patterns.box:        
        data >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
        data >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
        data >0000,>0000,>fc04,>f414 ; 05. Top right corner
        data >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
        data >1414,>1414,>1414,>1414 ; 07. Right vertical double line
        data >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
        data >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
        data >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner        
        data >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner


tv.data.colorscheme:                ; Foreground | Background | Bg. Pane
        data  >f404                 ; White      | Dark blue  | Dark blue
        data  >f101                 ; White      | Black      | Black
        data  >1707                 ; Black      | Cyan       | Cyan
        data  >1f0f                 ; Black      | White      | White
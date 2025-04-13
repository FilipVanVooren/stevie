* FILE......: data.constants.asm
* Purpose...: Stevie Editor - data segment (constants)

***************************************************************
*                      Constants
********|*****|*********************|**************************

***************************************************************
* Sprite Attribute Table
*--------------------------------------------------------------
romsat:
                                    ; YX, initial shape and color
        data  >0000,>8201           ; Cursor
        data  >0000,>8301           ; Current line indicator     <
        data  >0820,>8401           ; Current column indicator   v
nosprite:
        data  >d000                 ; End-of-Sprites list


***************************************************************
* Stevie color schemes table
*--------------------------------------------------------------
* ;
* ; Word 1
* ; A  MSB  high-nibble    Foreground color text line in frame buffer
* ; B  MSB  low-nibble     Background color text line in frame buffer
* ; C  LSB  high-nibble    Foreground color top/bottom line
* ; D  LSB  low-nibble     Background color top/bottom line
* ;
* ; Word 2
* ; E  MSB  high-nibble    Foreground color cmdb pane
* ; F  MSB  low-nibble     Background color cmdb pane
* ; G  LSB  high-nibble    Cursor foreground color cmdb pane
* ; H  LSB  low-nibble     Cursor foreground color frame buffer
* ;
* ; Word 3
* ; I  MSB  high-nibble    Foreground color busy top/bottom line
* ; J  MSB  low-nibble     Background color busy top/bottom line
* ; K  LSB  high-nibble    Foreground color marked line in frame buffer
* ; L  LSB  low-nibble     Background color marked line in frame buffer
* ;
* ; Word 4
* ; M  MSB  high-nibble    Foreground color command buffer header line
* ; N  MSB  low-nibble     Background color command buffer header line
* ; O  LSB  high-nibble    Foreground color line+column indicator frame buffer
* ; P  LSB  low-nibble     Foreground color ruler frame buffer
*
* ; Colors
* ; 0  Transparant
* ; 1  black      
* ; 2  Green      
* ; 3  Light Green
* ; 4  Blue       
* ; 5  Light Blue 
* ; 6  Dark Red   
* ; 7  Cyan       
* ; 8  Red
* ; 9  Light Red
* ; A  Yellow
* ; B  Light Yellow
* ; C  Dark Green
* ; D  Magenta
* ; E  Grey
* ; F  White
*--------------------------------------------------------------
tv.colorscheme.entries  equ 12        ; Entries in table

tv.colorscheme.table:
        ;                             ; 
        ;      ABCD  EFGH  IJKL  MNOP ; 
        data  >f417,>f171,>1b1f,>7111 ; 1  White on blue with cyan touch (1)
        data  >21f0,>21ff,>f112,>21ff ; 2  Dark green on black (minimalistic)
        data  >a11a,>f0ff,>1f1a,>f1ff ; 3  Dark yellow on black
        data  >1e1e,>1e11,>1ee1,>1e11 ; 4  Black on grey (minimalistic)        
        data  >f417,>7171,>1b1f,>7111 ; 5  White on blue with cyan touch (2)
        data  >1313,>1311,>1331,>1311 ; 6  Black on light green (minimalistic)
        data  >1771,>1011,>0171,>1711 ; 7  Black on cyan        
        data  >2112,>f0ff,>1f12,>f1f6 ; 8  Dark green on black         
        data  >1ff1,>1011,>f1f1,>1f11 ; 9  Black on white
        data  >1af1,>a111,>1f1f,>f11f ; 10 Black on dark yellow
        data  >1919,>1911,>1991,>1911 ; 11 Black on light red (minimalistic)
        data  >f41f,>f1f1,>1b1f,>7111 ; 12  White on blue with cyan touch (3)
        even

***************************************************************
* Tab positions
********|*****|*********************|**************************
tv.tabs.table.lr:
        byte  0,7,12,25             ; \   Default tab positions as used
        byte  30,45,59,79           ; |   in Editor/Assembler module.
        byte  >ff,0,0,0             ; |   Up to 11 positions supported.
                                    ; /   >ff means end-of-list.

tv.tabs.table.rl:
        byte  79,59,45,30           ; \   Default tab positions as used
        byte  25,12,7,0             ; |   in Editor/Assembler module.
        byte  >ff,0,0,0             ; |   Up to 11 positions supported.
                                    ; /   >ff means end-of-list.

***************************************************************
* Constants for numbers 0-10
********|*****|*********************|**************************
const.0       equ   w$0000          ; 0
const.1       equ   w$0001          ; 1
const.2       equ   w$0002          ; 2
const.3       data  3               ; 3
const.4       equ   w$0004          ; 4
const.5       data  5               ; 5
const.6       data  6               ; 6
const.7       data  7               ; 7
const.8       equ   w$0008          ; 8
const.9       data  9               ; 9
const.10      data  10              ; 10 ; A
const.11      data  11              ; 11 ; B
const.12      data  12              ; 12 ; C
const.13      data  13              ; 13 ; D
const.14      data  14              ; 14 ; E
const.15      data  15              ; 15 ; F
const.32      data  32              ; 32
const.80      data  80              ; 80

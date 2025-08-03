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
const.16      data  16              ; 16
const.32      data  32              ; 32
const.80      data  80              ; 80

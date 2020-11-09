* FILE......: data.constants.asm
* Purpose...: Stevie Editor - data segment (constants)

***************************************************************
*                      Constants
********|*****|*********************|**************************


***************************************************************
* Textmode (80 columns, 30 rows) - F18A
*--------------------------------------------------------------
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=1: M1 \ TEXT MODE
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=0: 8x8 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
* ; VDP#3 PCT (Pattern color table)      at >0FC0  (>3F * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >1000  (>02 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >2180  (>43 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************
stevie.tx8030:
        byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80

romsat:
        data  >0303,>0001             ; Cursor YX, initial shape and colour

cursors:
        data  >0000,>0000,>0000,>001c ; Cursor 1 - Insert mode
        data  >1010,>1010,>1010,>1000 ; Cursor 2 - Insert mode
        data  >1c1c,>1c1c,>1c1c,>1c00 ; Cursor 3 - Overwrite mode

patterns:
        data  >0000,>0000,>00ff,>0000 ; 01. Single line
        data  >0080,>0000,>ff00,>ff00 ; 02. Ruler + double line bottom 

patterns.box:        
        data  >0000,>0000,>ff00,>ff00 ; 03. Double line bottom
        data  >0000,>0000,>ff80,>bfa0 ; 04. Top left corner
        data  >0000,>0000,>fc04,>f414 ; 05. Top right corner
        data  >a0a0,>a0a0,>a0a0,>a0a0 ; 06. Left vertical double line
        data  >1414,>1414,>1414,>1414 ; 07. Right vertical double line
        data  >a0a0,>a0a0,>bf80,>ff00 ; 08. Bottom left corner
        data  >1414,>1414,>f404,>fc00 ; 09. Bottom right corner
        data  >0000,>c0c0,>c0c0,>0080 ; 10. Double line top left corner        
        data  >0000,>0f0f,>0f0f,>0000 ; 11. Double line top right corner


patterns.cr:
        data  >6c48,>6c48,>4800,>7c00 ; 12. FF (Form Feed)
        data  >0024,>64fc,>6020,>0000 ; 13. CR (Carriage return) - arrow

        
alphalock:
        data  >0000,>00e0,>e0e0,>e0e0 ; 14. alpha lock down
        data  >00e0,>e0e0,>e0e0,>0000 ; 15. alpha lock up


vertline:
        data  >1010,>1010,>1010,>1010 ; 16. Vertical line


***************************************************************
* SAMS page layout table for Stevie (16 words)
*--------------------------------------------------------------
mem.sams.layout.data:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a

        data  >b000,>0010           ; >b000-bfff, SAMS page >10                                    
                                    ; \ The index can allocate
                                    ; / pages >10 to >2f.
                                    
        data  >c000,>0030           ; >c000-cfff, SAMS page >30
                                    ; \ Editor buffer can allocate
                                    ; / pages >30 to >ff.
                                
        data  >d000,>000d           ; >d000-dfff, SAMS page >0d
        data  >e000,>000e           ; >e000-efff, SAMS page >0e
        data  >f000,>000f           ; >f000-ffff, SAMS page >0f        





***************************************************************
* Stevie color schemes table   
*--------------------------------------------------------------
* Word 1
* A  MSB  high-nibble    Foreground color frame buffer
* B  MSB  low-nibble     Background color frame buffer
* C  LSB  high-nibble    Foreground color bottom line 
* D  LSB  low-nibble     Background color bottom line
*
* Word 2
* E  MSB  high-nibble    Foreground color cmdb pane
* F  MSB  low-nibble     Background color cmdb pane
* G  LSB  high-nibble    0
* H  LSB  low-nibble     Cursor foreground color
*
* Word 3
* I  MSB  high-nibble    Foreground color busy bottom line
* J  MSB  low-nibble     Background color busy bottom line
* K  LSB  high-nibble    0
* L  LSB  low-nibble     0
*
* Word 4
* M  MSB  high-nibble    0
* N  MSB  low-nibble     0
* O  LSB  high-nibble    0
* P  LSB  low-nibble     0
*--------------------------------------------------------------
tv.colorscheme.entries   equ 9      ; Entries in table

tv.colorscheme.table:                  
;                              ; #  AB          | CD          | EF    | GH
;       ABCD  EFGH  IJKL  MNOP ; ---------------|-------------|-------|---------
 data  >f41f,>f001,>1b00,>0000 ; 1  whit/dblue  | black/whit  | whit  | black
 data  >f41c,>f00f,>1b00,>0000 ; 2  whit/dblue  | black/dgreen| whit  | whit
 data  >a11a,>f00f,>1b00,>0000 ; 3  yel/black   | black/dyel  | whit  | whit
 data  >2112,>f00f,>1b00,>0000 ; 4  mgreen/black| black/mgreen| white | whit
 data  >e11e,>f00f,>1b00,>0000 ; 5  grey/black  | black/grey  | white | whit
 data  >1771,>1006,>1b00,>0000 ; 6  black/cyan  | cyan/black  | black | ?
 data  >1ff1,>1001,>1b00,>0000 ; 7  black/whit  | whit/black  | black | black
 data  >a1f0,>1a0f,>1b00,>0000 ; 8  dyel/black  | whit/trnsp  | inver | whit
 data  >21f0,>f20f,>1b00,>0000 ; 9  mgreen/black| whit/trnsp  | inver | whit
 

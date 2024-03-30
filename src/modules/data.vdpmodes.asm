* FILE......: data.vdp.modes.asm
* Purpose...: VDP modes tables

            aorg bankx.vdptab

; ====================================================================
; Keep the tables in sequence, or change offsets in equ.f18a.*.asm
; ====================================================================

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
stevie.80x30:
        byte  >04,>f0,>00,>3f,>02,>43,>05,SPFCLR,0,80


***************************************************************
* TI Basic mode (32 columns/24 rows)
*--------------------------------------------------------------
tibasic.32x24:
        byte  >00,>e2,>00,>0c,>00,>06,>00,>07,0,32
*
* ; VDP#0 Control bits
* ;      bit 6=0: M3 | Graphics 1 mode
* ;      bit 7=0: Disable external VDP input
* ; VDP#1 Control bits
* ;      bit 0=1: 16K selection
* ;      bit 1=1: Enable display
* ;      bit 2=1: Enable VDP interrupt
* ;      bit 3=0: M1 \ Graphics 1 mode
* ;      bit 4=0: M2 /
* ;      bit 5=0: reserved
* ;      bit 6=1: 16x16 sprites
* ;      bit 7=0: Sprite magnification (1x)
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >400)
* ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color

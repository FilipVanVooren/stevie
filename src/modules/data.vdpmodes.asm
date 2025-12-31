* FILE......: data.vdp.modes.asm
* Purpose...: VDP modes tables

            aorg bankx.vdptab

; ====================================================================
; Keep the tables in sequence, or change offsets in equ.vdp.*.asm
; ====================================================================

***************************************************************
* Textmode (80 columns, 30 rows) - F18A
*--------------------------------------------------------------
*
* ; VDP#0 Control bits
* ;      bit 0=0: reserved
* ;      bit 1=0: reserved
* ;      bit 2=0: reserved
* ;      bit 3=0: reserved
* ;      bit 4=0: PICO9918 double rows mode (48, 60)
* ;      bit 5=1: 80-columns mode F18A/PICO9918
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
* ; VDP#3 PCT (Pattern color table)      at >12c0  (>4b * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >2800  (>05 * >800)
* ; VDP#5 SAT (sprite attribute table)   at >2580  (>4b * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >2800  (>05 * >800)
* ; VDP#7 Set foreground/background color
***************************************************************
stevie.80x30:
       ; VDP#0 
   .ifeq vdpmode, 2480
       byte   >04
   .endif
   .ifeq vdpmode, 3080
       byte   >04
   .endif               
   .ifeq vdpmode, 4880
       byte   >0c
   .endif       
   .ifeq vdpmode, 6080
       byte   >0c
   .endif
       ; VDP#1 - VDP#7
       byte   >f0,>00,>4b,>05,>4b,>05,SPFCLR,0,80


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
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
* ; VDP#3 PCT (Pattern color table)      at >0300  (>0C * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0000  (>00 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color


***************************************************************
* Editor/Assembler (32 columns/24 rows)
*--------------------------------------------------------------
edasm.32x24:
        byte  >00,>e2,>00,>0e,>01,>06,>00,>03,0,32
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
* ; VDP#2 PNT (Pattern name table)       at >0000  (>00 * >960)
* ; VDP#3 PCT (Pattern color table)      at >0380  (>0E * >040)
* ; VDP#4 PDT (Pattern descriptor table) at >0800  (>01 * >800)
* ; VDP#5 SAT (sprite attribute list)    at >0300  (>06 * >080)
* ; VDP#6 SPT (Sprite pattern table)     at >0000  (>00 * >800)
* ; VDP#7 Set screen background color

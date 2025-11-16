* FILE......: data.sams.layout.asm
* Purpose...: SAMS bank layout for Stevie


; Following 32K memory regions are locked with
; fixed SAMS pages while running Stevie:
;
;  ---------------------------------------
;  >2000-2fff  SAMS page >00      locked
;  >3000-3fff  SAMS page >01      locked
;  >a000-afff  SAMS page >04      locked
;  ---------------------------------------
;  >b000-bfff  SAMS page >20-3f   variable
;  >c000-cfff  SAMS page >40-ff   variable
;  ---------------------------------------
;  >d000-dfff  SAMS page >05      locked+
;  >e000-efff  SAMS page >06      locked+
;  >f000-ffff  SAMS page >07      locked+
;  ---------------------------------------
;
;  1. During index search/reorganization the index temporarily
;     extends into memory range d000-ffff swapping the
;     otherwise locked+ pages as required.
;
;  2. Only when en external program is running (e.g. TI Basic)
;     or when terminating Stevie, the legacy page layout table
;     gets reactivated.


***************************************************************
* SAMS page layout table 
* Stevie boot order
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >00  >01  >04  >20  >40  >05  >06  >07
*--------------------------------------------------------------
mem.sams.layout.boot:
        data  >0000                 ; >2000-2fff, SAMS page >02
        data  >0100                 ; >3000-3fff, SAMS page >03
        data  >0400                 ; >a000-afff, SAMS page >04
        data  >2000                 ; >b000-bfff, SAMS page >20
                                    ; \
                                    ; | Index can allocate
                                    ; | pages >20 to >3f.
                                    ; /
        data  >4000                 ; >c000-cfff, SAMS page >40
                                    ; \
                                    ; | Editor buffer can allocate
                                    ; | pages >40 to >ff.
                                    ; /
        data  >0500                 ; >d000-dfff, SAMS page >05
        data  >0600                 ; >e000-efff, SAMS page >06
        data  >0700                 ; >f000-ffff, SAMS page >07


***************************************************************
* SAMS page layout table 
* Before running external progam
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >00  >01  >04  >10  >11  >12  >13  >07
*--------------------------------------------------------------
mem.sams.layout.external:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1000                 ; >b000-efff, SAMS page >10
        data  >1100                 ; \
        data  >1200                 ; | Stevie session
        data  >1300                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07


***************************************************************
* SAMS legacy page layout table 
* While running external program
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >02  >03  >0a  >0b  >0c  >0d  >0e  >0f
*--------------------------------------------------------------
mem.sams.layout.legacy:
        data  >0200                 ; >2000-2fff, SAMS page >02
        data  >0300                 ; >3000-3fff, SAMS page >03
        data  >0a00                 ; >a000-afff, SAMS page >0a
        data  >0b00                 ; >b000-bfff, SAMS page >0b
        data  >0c00                 ; >c000-cfff, SAMS page >0c
        data  >0d00                 ; >d000-dfff, SAMS page >0d
        data  >0e00                 ; >e000-efff, SAMS page >0e
        data  >0f00                 ; >f000-ffff, SAMS page >0f


***************************************************************
* SAMS page layout table 
* Backup TI Basic session 1 VRAM, scratchpad + auxiliary
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >00  >01  >04  >fb  >fc  >fd  >fe  >ff
*--------------------------------------------------------------
mem.sams.layout.basic1:
        data  >0000                 ; . >2000-2fff
        data  >0100                 ; . >3000-3fff
        data  >0400                 ; . >a000-afff
        data  >fb00                 ; \ >b000-efff
        data  >fc00                 ; |
        data  >fd00                 ; | 16K VDP dump
        data  >fe00                 ; /
        data  >ff00                 ; . >f000-ffff


***************************************************************
* SAMS page layout table 
* Backup TI Basic session 2 VRAM, scratchpad + auxiliary
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >00  >01  >04  >f7  >f8  >f9  >fa  >ff
*--------------------------------------------------------------
mem.sams.layout.basic2:
        data  >0000                 ; . >2000-2fff
        data  >0100                 ; . >3000-3fff
        data  >0400                 ; . >a000-afff
        data  >f700                 ; \ >b000-efff
        data  >f800                 ; |
        data  >f900                 ; | 16K VDP dump
        data  >fa00                 ; /
        data  >ff00                 ; . >f000-ffff


***************************************************************
* SAMS page layout table 
* Backup TI Basic session 3 VRAM, scratchpad + auxiliary
* Addr:  2..  3..  A..  B..  C..  D..  E..  F..
* Page:  >00  >01  >04  >f3  >f4  >f5  >f6  >ff
*--------------------------------------------------------------
mem.sams.layout.basic3:
        data  >0000                 ; . >2000-2fff
        data  >0100                 ; . >3000-3fff
        data  >0400                 ; . >a000-afff
        data  >f300                 ; \ >b000-efff
        data  >f400                 ; |
        data  >f500                 ; | 16K VDP dump
        data  >f600                 ; /
        data  >ff00                 ; . >f000-ffff


***************************************************************
* SAMS page layout table 
* Run EA5 program image
*--------------------------------------------------------------
mem.sams.layout.ea5pgm:
        equ   mem.sams.layout.legacy


mem.sams.layout.basic  equ mem.sams.layout.basic1

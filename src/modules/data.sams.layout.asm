* FILE......: data.sams.layout.asm
* Purpose...: SAMS bank layout for multi-purpose


***************************************************************
* SAMS legacy page layout table (as in SAMS transparent mode)
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
* SAMS page layout table for Stevie boot order
*--------------------------------------------------------------
mem.sams.layout.boot:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
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
* SAMS page layout table before calling external progam
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
* SAMS page layout table for TI Basic session 1
*--------------------------------------------------------------
mem.sams.layout.basic1:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1400                 ; >b000-efff, SAMS page >14
        data  >1500                 ; \ 
        data  >1600                 ; | TI Basic session 1
        data  >1700                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07     


***************************************************************
* SAMS page layout table for TI Basic session 2
*--------------------------------------------------------------
mem.sams.layout.basic2:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1800                 ; >b000-efff, SAMS page >18
        data  >1900                 ; \ 
        data  >1a00                 ; | TI Basic session 2
        data  >1b00                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07            


***************************************************************
* SAMS page layout table for TI Basic session 3
*--------------------------------------------------------------
mem.sams.layout.basic3:
        data  >0000                 ; >2000-2fff, SAMS page >00
        data  >0100                 ; >3000-3fff, SAMS page >01
        data  >0400                 ; >a000-afff, SAMS page >04

        data  >1c00                 ; >b000-efff, SAMS page >1c
        data  >1d00                 ; \ 
        data  >1e00                 ; | TI Basic session 3
        data  >1f00                 ; | VDP content
                                    ; /
        data  >0700                 ; >f000-ffff, SAMS page >07                    
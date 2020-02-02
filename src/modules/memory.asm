* FILE......: memory.asm
* Purpose...: TiVi Editor - Memory management (SAMS)

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Memory Management
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.setup.sams.layout
* Setup SAMS memory pages for TiVi
***************************************************************
* bl  @mem.setup.sams.layout
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
mem.setup.sams.layout:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @sams.layout
              data mem.sams.layout.data
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.setup.sams.layout.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS page layout table for TiVi (16 words)
*--------------------------------------------------------------
mem.sams.layout.data:
        data  >2000,>0000           ; >2000-2fff, SAMS page >00
        data  >3000,>0001           ; >3000-3fff, SAMS page >01
        data  >a000,>0002           ; >a000-afff, SAMS page >02
        data  >b000,>0003           ; >b000-bfff, SAMS page >03
        data  >c000,>0004           ; >c000-cfff, SAMS page >04
        data  >d000,>0005           ; >d000-dfff, SAMS page >05
        data  >e000,>0006           ; >e000-efff, SAMS page >06
        data  >f000,>0007           ; >f000-ffff, SAMS page >07
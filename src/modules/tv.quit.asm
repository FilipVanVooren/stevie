* FILE......: tv.quit.asm
* Purpose...: Quit Stevie and return to monitor

***************************************************************
* tv.quit
* Quit stevie and return to monitor
***************************************************************
* b    @tv.quit
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
tv.quit:
        ;-------------------------------------------------------
        ; Reset/lock F18a
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A
        ;-------------------------------------------------------
        ; Set SAMS standard banks
        ;-------------------------------------------------------
        bl    @mem.sams.set.standard 
                                    ; Load standard SAMS page layout

        li    r12,>1e00             ; SAMS CRU address
        sbz   1                     ; Disable SAMS mapper

        clr   @bank0.rom            ; Activate bank 0                                    
        blwp  @0                    ; Reset to monitor
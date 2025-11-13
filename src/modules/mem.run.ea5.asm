
***************************************************************
* mem.run.ea5
* Run previously loaded EA5 memory image
***************************************************************
* INPUT
* parm1  = Pointer to start address in RAM
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r0, r1
*--------------------------------------------------------------
* Remarks
********|*****|*********************|**************************
mem.run.ea5:
        ;-------------------------------------------------------
        ; Prepare for running EA5 binary image
        ;------------------------------------------------------- 
        mov   @parm1,r1             ; Get start address in RAM


        bl    @scroff               ; Turn off screen

        bl    @mem.sams.set.external
                                    ; Load SAMS page layout (from cart space)
                                    ; before running external program.

        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Copy Stevie 16K VDP memory to RAM buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Reset F18A and set video mode
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic.32x24    ; Equate selected video mode table

        bl    @scron                ; Turn on screen
        ;-------------------------------------------------------
        ; Set SAMS banks to defaults. We're on our own now!
        ;-------------------------------------------------------
        li    r0,mem.sams.layout.legacy
        bl    @_mem.sams.set.banks  ; Set SAMS banks before leaving Stevie
        jmp   $        
        b     *r1                   ; Jump to EA5 program start address
        jmp   $
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
mem.run.ea5.exit:
        b     *r11                  ; Return
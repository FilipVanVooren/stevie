* FILE......: rom.dialogs2ram.asm
* Purpose...: Copy dialogs data from cartridge rom to ram

***************************************************************
* rom.dialog2ram
* Copy dialogs data from cartridge rom to ram
***************************************************************
* bl @rom.dialog2ram
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
* Dialog data resides in SAMS Bank #2 (>b000) and #3 (>c000)
********|*****|*********************|**************************
rom.dialogs2ram:
        .pushregs 2                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS page that has dialogs data
        ;-------------------------------------------------------
        bl    @sams.page.set        ; Set SAMS page
              data >0002,>b000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address

        bl    @sams.page.set        ; Set SAMS page
              data >0003,>c000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address        
        ;-------------------------------------------------------
        ; Copy dialogs
        ;-------------------------------------------------------
        bl    @cpym2m               ; Copy dialogs data to >b000
              data dialogs,>b000,enddial-dialogs
        ;-------------------------------------------------------
        ; Restore SAMS page
        ;-------------------------------------------------------
        mov   @tv.sams.b000,tmp0    ; \ Get SAMS page
        li    tmp1,>b000            ; /

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        mov   @tv.sams.c000,tmp0    ; \ Get SAMS page
        li    tmp1,>c000            ; /

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address                                                                      
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
rom.dialogs2ram.exit:
        .popregs 2                  ; Pop registers and return to caller

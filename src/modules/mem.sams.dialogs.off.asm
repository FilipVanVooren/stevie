***************************************************************
* mem.sams.dialogs.off
* Deactivate SAMS page #2 (>b000) and SAMS page #3 (>c000)
***************************************************************
* bl  @mem.sams.dialogs.off
*--------------------------------------------------------------
* INPUT
* @tv.sams.b000 = Current SAMS page mapped to >b000
* @tv.sams.c000 = Current SAMS page mapped to >c000
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
mem.sams.dialogs.off:
        .pushregs 2                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
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
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
sams.dialogs.off.exit:
        .popregs 2                  ; Pop registers and return to caller

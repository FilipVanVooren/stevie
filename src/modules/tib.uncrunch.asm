* FILE......: tib.uncrunch.prep.asm
* Purpose...: Uncrunch TI Basic program to editor buffer


***************************************************************
* tib.uncrunch
* Uncrunch TI Basic program to editor buffer
***************************************************************
* bl   @tib.uncrunch
*--------------------------------------------------------------
* INPUT
* @parm1 = TI Basic session to uncrunch (1-5)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
********|*****|*********************|**************************
tib.uncrunch:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Prepare for uncrunching
        ;------------------------------------------------------
        bl    @tib.uncrunch.prepare ; Prepare for uncrunching TI Basic program
                                    ; \ i  @parm1 = TI Basic session to uncrunch
                                    ; /
        ;------------------------------------------------------
        ; Uncrunch TI Basic program
        ;------------------------------------------------------
        bl    @tib.uncrunch.prg     ; Uncrunch TI Basic program
        ;------------------------------------------------------
        ; Prepare for exit
        ;------------------------------------------------------
        mov   @tv.sams.f000,tmp0    ; Get SAMS page number
        li    tmp1,>f000            ; Map SAMS page to >f000-ffff

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address

        bl    @fb.refresh           ; Refresh frame buffer content
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

* FILE......: tv.set.font.asm
* Purpose...: Set current font


***************************************************************
* tv.set.font
* Set current font (dumps font to VDP)
***************************************************************
* bl @tv.set.font
*--------------------------------------------------------------
* INPUT
* @parm1 = Index of font to activate (0-5)
*--------------------------------------------------------------
* OUTPUT
* @tv.font.ptr = Pointer to current font
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
*--------------------------------------------------------------
* Notes
* Dumps current font to VDP
********|*****|*********************|**************************
tv.set.font:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1        
        ;------------------------------------------------------
        ; Assert check index
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get index
        ci    tmp0,5                ; Valid index entry?
        jle   tv.set.font.ptr       ; Yes, set pointer
        ;------------------------------------------------------
        ; Assert failed
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Set pointer to font
        ;------------------------------------------------------
tv.set.font.ptr:
        li    tmp0,784              ; Size of font dump (in bytes)
        mpy   @parm1,tmp0           ; Result is in tmp1
        ai    tmp1,font1            ; Add font base address
        mov   tmp1,@tv.font.ptr     ; Set pointer
        ;------------------------------------------------------
        ; Dump font to VDP
        ;------------------------------------------------------        
tv.set.font.vdpdump:        
        bl    @vdp.dump.font        ; Dump font to VDP
                                    ; \ i  @tv.font.ptr = Pointer to font in ROM
                                    ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.set.font.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

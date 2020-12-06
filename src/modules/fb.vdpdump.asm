* FILE......: fb.vdpdump.asm
* Purpose...: Dump framebuffer to VDP


***************************************************************
* fb.vdpdump
* Dump framebuffer to VDP SIT
***************************************************************
* bl @fb.vdpdump
*--------------------------------------------------------------
* INPUT
* @parm1 = Number of lines to copy
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fb.vdpdump:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Refresh VDP content with framebuffer
        ;------------------------------------------------------        
        li    tmp0,vdp.fb.toprow.sit 
                                    ; VDP target address (2nd line on screen!)

        mov   @parm1,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * number of rows in parm1
                                    ; 16 bit part is in tmp2!
        mov   @fb.top.ptr,tmp1      ; RAM Source address

        ci    tmp2,0                ; \ Exit early if nothing to copy
        jeq   fb.vdpdump.exit       ; / 

        bl    @xpym2v               ; Copy to VDP
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Bytes to copy

        clr   @fb.dirty             ; Reset frame buffer dirty flag
        seto  @fb.colorize          ; Colorize M1/M2 block (if present)        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.vdpdump.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

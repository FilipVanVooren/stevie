* FILE......: fb.vdpdump.asm
* Purpose...: Dump framebuffer to VDP


***************************************************************
* fb.vdpdump
* Dump framebuffer to VDP SIT
***************************************************************
* bl @fb.vdpdump
*--------------------------------------------------------------
* INPUT
* @parm1 = Number of lines to dump
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fb.vdpdump:
        .pushregs 2                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------ 
        mov   @parm1,tmp1
        ci    tmp1,80*30
        jle   ! 
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Setup start position in VDP memory
        ;------------------------------------------------------        
!       li    tmp0,vdp.fb.toprow.sit 
                                    ; VDP target address (Xth line on screen!)
        mov   @tv.ruler.visible,tmp2
                                    ; Is ruler visible on screen?
        jeq   fb.vdpdump.calc       ; No, continue with calculation
        a     @fb.colsline,tmp0     ; Yes, add 2nd line offset
        ;------------------------------------------------------
        ; Refresh VDP content with framebuffer
        ;------------------------------------------------------   
fb.vdpdump.calc:
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
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.vdpdump.exit:
        .popregs 2                  ; Pop registers and return to caller                

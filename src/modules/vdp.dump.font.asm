* FILE......: vdpdump.font.asm
* Purpose...: Dump sprite/character patterns to VDP

***************************************************************
* vdp.dump.font
* Dump font to VDP
***************************************************************
* bl @vdpdump.font
*--------------------------------------------------------------
* INPUT
* @tv.font.ptr = Pointer to font in ROM/RAM
*--------------------------------------------------------------
* OUTPUT
* None
*--------------------------------------------------------------
* REMARK
* None
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
***************************************************************
vdp.dump.font:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2              
        ;-------------------------------------------------------
        ; Dump from ROM to VDP PDT
        ;-------------------------------------------------------
        li    tmp0,fntadr           ; VDP destination
        mov   @tv.font.ptr,tmp1     ; Get pointer to font in ROM/RAM
        ai    tmp1,16               ; Skip definitions for ASCII 30 + ASCII 31
        li    tmp2,784 - 16         ; Bytes to dump

        bl    @xpym2v               ; Copy CPU memory to VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = CPU source
                                    ; / i  tmp2 = Number of bytes to copy
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
vdp.dump.font.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to task

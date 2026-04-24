* FILE......: vdpdump.font.asm
* Purpose...: Dump character patterns to VDP

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
* tmp0,tmp1,tmp2
***************************************************************
vdp.dump.font:
        .pushregs 2                 ; Push return address and registers on stack
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
        .popregs 2                  ; Pop registers and return to caller

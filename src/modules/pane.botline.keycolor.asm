* FILE......: pane.botline.keycolor.asm
* Purpose...: Colorize key markers on bottom line using cmdb.keycolors array

***************************************************************
* pane.botline.keycolor
* Colorize key markers in bottom line using pointer at @cmdb.keycolors
***************************************************************
* bl  @pane.botline.keycolor
*--------------------------------------------------------------
* INPUT
* none (reads pointer from @cmdb.keycolors)
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
********|*****|*********************|**************************
pane.botline.keycolor:
        .pushregs 5                ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Get pointer to key color array
        ;------------------------------------------------------
        mov   @cmdb.keycolors,tmp0  ; tmp0 = pointer to byte array (pos,color,pos,color,..,>ff)
        jeq   pane.botline.keycolor.exit ; Nothing to do
        ;------------------------------------------------------
        ; Ensure we have current color scheme data available
        ; This fills @outparm1..@outparm5 where outparm5 contains QRST
        ;------------------------------------------------------
        bl    @pane.colorscheme.index
        ; Get key-marker default background nibble (T)
        ; Extract T (background nibble for key markers) from outparm5 (QRST)
        mov   @outparm5,tmp2        ; tmp2 = QRST
        andi  tmp2,>000f            ; tmp2 = T (low nibble)
        ;------------------------------------------------------
        ; Loop through array of (X,color) pairs
        ;------------------------------------------------------
pane.botline.keycolor.loop:
        movb  *tmp0+,tmp3          ; Read X position (byte)
        srl   tmp3,8               ; Move to LSB
        ci    tmp3,>ff             ; Check sentinel
        jeq   pane.botline.keycolor.done
        movb  *tmp0+,tmp4          ; Read color index (byte)
        srl   tmp4,8               ; Move to LSB (color nibble expected)
        ; Build TAT byte: FG = color index (4-bit) in high nibble, BG = scheme T in low nibble
        andi  tmp4,>000f           ; keep low nibble of color index
        sla   tmp4,4               ; shift into high nibble
        soc   tmp2,tmp4            ; tmp4 = tmp4 | tmp2  (combined TAT byte)
        ; Build WYX value with Y=pane.botrow and X=tmp3
        li    tmp1,pane.botrow     ; tmp1 = Y
        sla   tmp1,8               ; tmp1 = Y<<8
        a     tmp1,tmp3            ; tmp1 = (Y<<8) + X
        mov   tmp1,@wyx            ; Set global WYX
        bl    @yx2pnt              ; Calculate VDP address from @WYX, result in tmp0
        ai    tmp0,vdp.tat.base    ; Add TAT base
        mov   tmp4,tmp1            ; tmp1 = TAT byte to write
        bl    @xvputb              ; VDP put single byte
        jmp   pane.botline.keycolor.loop

pane.botline.keycolor.done:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.keycolor.exit:
        .popregs 5                 ; Pop registers and return to caller

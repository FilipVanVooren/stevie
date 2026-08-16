* FILE......: pane.botline.keycolor.asm
* Purpose...: Colorize key markers on bottom line using cmdb.keycolors array

***************************************************************
* pane.botline.keycolor
* Colorize key markers in bottom line using pointer at @cmdb.keycolors
***************************************************************
* bl  @pane.botline.keycolor
*--------------------------------------------------------------
* INPUT
* @cmdb.keycolors = Pointer to byte array with marker positions
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0 = pointer to keycolors array
* tmp1 = TAT byte (final color to write)
* tmp2 = Y<<8 base
* tmp3 = X position
* tmp4 = repeat count
* tmp5 = temporary / address calc
********|*****|*********************|**************************
pane.botline.keycolor:
        .pushregs 6                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Get pointer to key color array
        ;------------------------------------------------------
        mov   @cmdb.keycolors,tmp0  ; tmp0 = pointer to byte array (X,count,...,>ff)
        jeq   pane.botline.keycolor.exit 
        ;------------------------------------------------------
        ; Ensure we have current color scheme data available
        ; This fills @outparm1..@outparm5 where outparm5 contains QRST
        ;------------------------------------------------------
        bl    @pane.colorscheme.index
        ; Compose final TAT byte from QRST: FG=S (high nibble of low byte), BG=T (low nibble)
        mov   @outparm5,tmp5        ; tmp5 = QRST
        andi  tmp1,>0000            ; clear tmp1
        andi  tmp5,>00f0            ; isolate S in high nibble of low byte
        srl   tmp5,4                ; S as low nibble
        sla   tmp5,4                ; S<<4 in tmp5
        mov   @outparm5,tmp1        ; tmp1 = QRST (reload)
        andi  tmp1,>000f            ; tmp1 = T (low nibble)
        soc   tmp5,tmp1            ; tmp5 = S<<4 | T
        mov   tmp5,tmp1            ; tmp1 = final TAT byte (ready for xvputb)
        ; Precompute Y<<8 base in tmp2
        li    tmp2,pane.botrow
        sla   tmp2,8
        ;------------------------------------------------------
        ; Loop through array of (X,repeat) pairs
        ; Each entry: X pos (byte), repeat count (byte). Terminator: >ff
        ;------------------------------------------------------
pane.botline.keycolor.loop:
        movb  *tmp0+,tmp3          ; Read X position (byte)
        srl   tmp3,8               ; Move to LSB
        ci    tmp3,>ff             ; Check sentinel
        jeq   pane.botline.keycolor.done
        movb  *tmp0+,tmp4          ; Read repeat count (byte)
        srl   tmp4,8               ; Move to LSB (repeat count)
        ; If repeat count is zero, skip
        ci    tmp4,0
        jeq   pane.botline.keycolor.loop
        ; Prepare base Y<<8 in tmp1 (precomputed)
        ; tmp1 already contains Y<<8
        ; tmp2 contains final TAT byte
        ; Loop to write TAT to consecutive X positions
pane.botline.keycolor.repeat_loop:
        ; Save pointer tmp0 on stack because yx2pnt returns result in tmp0
        dect  stack
        mov   tmp0,*stack
        ; Build WYX value with Y=pane.botrow and X=tmp3
        mov   tmp2,tmp5            ; tmp5 = working copy of Y<<8
        a     tmp5,tmp3            ; tmp5 = (Y<<8) + Xpos
        mov   tmp5,@wyx            ; Set global WYX
        bl    @yx2pnt              ; Calculate VDP address from @WYX, result in tmp0
        ai    tmp0,vdp.tat.base    ; Add TAT base
        ; tmp1 already contains TAT byte (computed earlier)
        bl    @xvputb              ; VDP put single byte (tmp1)
        ; Restore pointer tmp0 from stack
        mov   *stack+,tmp0
        ; Advance Xpos and decrement count
        inc   tmp3
        dec   tmp4
        jne   pane.botline.keycolor.repeat_loop
        jmp   pane.botline.keycolor.loop

pane.botline.keycolor.done:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.keycolor.exit:
        .popregs 6                 ; Pop registers and return to caller

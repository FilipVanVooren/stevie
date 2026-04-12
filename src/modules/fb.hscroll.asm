* FILE......: fb.hscroll.asm
* Purpose...: Horizontal scroll frame buffer window

***************************************************************
* fb.hscroll.asm
* Horizontal scroll frame buffer window
***************************************************************
*  bl   @fb.hscroll.asm
*--------------------------------------------------------------
* INPUT
* @parm1 = View Window Column Offset
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fb.hscroll:
        .pushregs 2                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set View Window Column Offset
        ;-------------------------------------------------------
        mov   @parm1,@fb.vwco       ; Set View Window Column Offset

        seto  @fb.status.dirty      ; Trigger refresh of status lines
        seto  @fb.dirty             ; Trigger refresh

        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.hscroll.exit:
        .popregs 2                  ; Pop registers and return to caller                

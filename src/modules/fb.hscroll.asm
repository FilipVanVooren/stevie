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
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
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
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
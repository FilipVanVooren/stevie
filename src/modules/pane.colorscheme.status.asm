* FILE......: pane.colorscheme.status.asm
* Purpose...: Set color combination for status lines

***************************************************************
* pane.colorscheme.statlines
* Set color combination for status lines
***************************************************************
* bl @pane.colorscheme.statlines
*--------------------------------------------------------------
* INPUT
* @parm1 = Color combination to set
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.colorscheme.statlines:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Bottom line
        ;------------------------------------------------------
        li    tmp0,pane.botrow
        mov   tmp0,@parm2           ; Last row on screen
        bl    @vdp.colors.line      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.colorscheme.statlines.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

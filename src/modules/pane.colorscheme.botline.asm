* FILE......: pane.colorscheme.botline.asm
* Purpose...: Set color combination for bottom status line

***************************************************************
* pane.colorscheme.botline
* Set color combination for bottom status line
***************************************************************
* bl @pane.colorscheme.botline
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
pane.colorscheme.botline:
        .pushregs 0                 ; Push return address and registers on stack
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
pane.colorscheme.botline.exit:
        .popregs 0                  ; Pop registers and return to caller

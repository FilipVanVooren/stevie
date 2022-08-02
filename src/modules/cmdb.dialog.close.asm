* FILE......: cmdb.dialog.close
* Purpose...: Close dialog

***************************************************************
* cmdb.dialog.close
* Close dialog
***************************************************************
* bl   @cmdb.dialog.close
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
cmdb.dialog.close:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Close dialog
        ;------------------------------------------------------
        clr   @cmdb.dialog          ; Reset dialog ID
        bl    @pane.cmdb.hide       ; Hide command buffer pane
        seto  @fb.status.dirty      ; Trigger status lines update
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
cmdb.dialog.close.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

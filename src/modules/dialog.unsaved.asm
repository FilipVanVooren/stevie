* FILE......: dialog.unsaved.asm
* Purpose...: Dialog "Unsaved changes"

***************************************************************
* dialog.unsaved
* Open Dialog "Unsaved changes"
***************************************************************
* b @dialog.unsaved
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.unsaved:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.unsaved
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.unsaved
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.unsaved
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.unsaved
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.unsaved
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.unsaved.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

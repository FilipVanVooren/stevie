* FILE......: dialog.editor.asm
* Purpose...: Dialog "Configure editor"

***************************************************************
* dialog.editor
* Dialog "Configure editor"
***************************************************************
* bl @dialog.editor
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
dialog.editor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.editor
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.editor
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.editor
        mov   tmp0,@cmdb.paninfo    ; Show info message
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.editor
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.editor
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.editor.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

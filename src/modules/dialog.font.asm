* FILE......: dialog.font.asm
* Purpose...: Dialog "Configure font"

***************************************************************
* dialog.font
* Open Dialog for configuring font
***************************************************************
* bl @dialog.font
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
dialog.font:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.font.setup:
        li    tmp0,id.dialog.font
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.font
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,pos.info.font
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        ;------------------------------------------------------
        ; Other panel strings
        ;------------------------------------------------------
        li    tmp0,txt.hint.font
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.info.font
        mov   tmp0,@cmdb.paninfo    ; Show info message
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.font.keylist:
        li    tmp0,txt.keys.font
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.font.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: dialog.config.asm
* Purpose...: Dialog "Configure"

***************************************************************
* dialog.config
* Open Dialog "Configure"
***************************************************************
* bl @dialog.config
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
dialog.config:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.config
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.config
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.config
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.config
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.config
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.config
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.config.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: dialog.shortcuts.asm
* Purpose...: Dialog "Shortcuts"

***************************************************************
* dialog.shortcuts
* Open Dialog "Shortcuts"
***************************************************************
* b @dialog.shortcuts
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
dialog.shortcuts:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.shortcuts
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.shortcuts
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.shortcuts
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.shortcuts
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.shortcuts
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.shortcuts
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.shortcuts.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

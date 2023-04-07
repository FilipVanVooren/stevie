* FILE......: dialog.help.asm
* Purpose...: Dialog "Help"

*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
dialog.help:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        bl    @scroff               ; turn screen off

        li    tmp0,id.dialog.help
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        bl    @dialog.help.content  ; display content in modal dialog

        li    tmp0,txt.head.about
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.about.build
        mov   tmp0,@cmdb.paninfo    ; Info line
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.about
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line
        li    tmp0,txt.hint.about2
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.help.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

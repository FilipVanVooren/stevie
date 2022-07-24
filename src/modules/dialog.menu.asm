* FILE......: dialog.menu.asm
* Purpose...: Dialog "Main Menu"

***************************************************************
* dialog.menu
* Open Dialog "Main Menu"
***************************************************************
* bl @dialog.menu
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
dialog.menu:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.menu
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.menu
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.menu
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menu
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.menu
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.keys.menu
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.menu.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

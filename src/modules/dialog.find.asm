* FILE......: dialog.find.asm
* Purpose...: Dialog "Find"

***************************************************************
* dialog.find
* Dialog "Find"
***************************************************************
* bl @dialog.find
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
dialog.find:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------        
        li    tmp0,id.dialog.find
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.find
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message
        clr   @cmdb.panmarkers      ; No letter markers
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.hint.find
        mov   tmp0,@cmdb.panhint    ; Show 'Enter search string.'

        li    tmp0,txt.hint.find2
        mov   tmp0,@cmdb.panhint2   ; Show toggle

        li    tmp0,txt.keys.find
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.blink    ; Show cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.find.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: dialog.find.browse.asm
* Purpose...: Dialog "Find - Search results"

***************************************************************
* dialog.find.browse
* Dialog "Find - Search results"
***************************************************************
* bl @dialog.find.browse
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
dialog.find.browse:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------        
        li    tmp0,id.dialog.find.browse
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.find.browse
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message
        clr   @cmdb.panmarkers      ; No letter markers
        clr   @cmdb.panhint         ; No hint to display
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.keys.find.browse
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.find.browse.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: dialog.clock.asm
* Purpose...: Dialog "Configure Clock"

***************************************************************
* dialog.clock
* Open Dialog for clock configuration
***************************************************************
* bl @dialog.clock
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
dialog.clock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.clock.setup:
        li    tmp0,id.dialog.clock
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        ;------------------------------------------------------
        ; Other panel strings
        ;------------------------------------------------------
        li    tmp0,txt.hint.clock
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.info.clock
        mov   tmp0,@cmdb.paninfo    ; Show info message

        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.ws4          ; \ Empty hint
        mov   tmp0,@cmdb.panhint2   ; / 

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.clock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

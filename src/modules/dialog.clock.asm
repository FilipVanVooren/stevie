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
        .pushregs 0                 ; Push return address and registers on stack
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
        .popregs 0                  ; Pop registers and return to caller

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
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
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

        li    tmp0,col.keys.font
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers              

        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)             
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.font.exit:
        .popregs 0                  ; Pop registers and return to caller

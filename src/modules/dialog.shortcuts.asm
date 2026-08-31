* FILE......: dialog.shortcuts.asm
* Purpose...: Dialog "Shortcuts"

***************************************************************
* dialog.shortcuts
* Dialog "Shortcuts"
***************************************************************
* bl @dialog.shortcuts
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
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
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

        li    tmp0,txt.ws4
        mov   tmp0,@cmdb.panhint2   ; No extra hint to display

        li    tmp0,txt.hint.shortcuts
        mov   tmp0,@cmdb.panhint    ; Empty hint

        li    tmp0,txt.keys.shortcuts
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.shortcuts
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers

        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)            
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.shortcuts.exit:
        .popregs 0                  ; Pop registers and return to caller

* FILE......: dialog.opt.asm
* Purpose...: Dialog "Options"

***************************************************************
* dialog.opt
* Open Dialog "Options"
***************************************************************
* bl @dialog.opt
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
dialog.opt:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)             
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.opt
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.config
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        ;-------------------------------------------------------
        ; Editor buffer locked?
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor locked?
        jeq   !                     ; No, show all options
        ;-------------------------------------------------------
        ; Reduced options
        ;-------------------------------------------------------
        li    tmp0,txt.info.conflock
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.conflock
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        jmp   dialog.opt.keylist
        ;-------------------------------------------------------
        ; All options
        ;-------------------------------------------------------
!       li    tmp0,txt.info.config
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.config
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        ;-------------------------------------------------------
        ; Rest of dialog setup
        ;-------------------------------------------------------
dialog.opt.keylist:
        clr   @cmdb.panhint         ; No hint to display
        clr   @cmdb.panhint2        ; No extra hint to display
 
        li    tmp0,txt.keys.config
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.config
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers              

        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)             
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.opt.exit:
        .popregs 0                  ; Pop registers and return to caller

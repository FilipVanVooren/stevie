* FILE......: dialog.opt.clip.asm
* Purpose...: Dialog "Configure clipboard"

***************************************************************
* dialog.opt.clip
* Open Dialog "Configure clipboard"
***************************************************************
* bl @dialog.opt.clip
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
dialog.opt.clip:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.opt.clip
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.clipdev
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.clipdev
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.keys.clipdev
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.clipdev
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers              
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
        li    tmp0,tv.clip.fname    ; Set clipboard
        mov   tmp0,@parm1           ; Get pointer to string

        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
        bl    @pane.cursor.blink    ; Show cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)                
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.opt.clip.exit:
        .popregs 0                  ; Pop registers and return to caller

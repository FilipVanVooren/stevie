* FILE......: dialog.file.append.asm
* Purpose...: Dialog "Append file"

***************************************************************
* dialog.append
* Open Dialog "Append file"
***************************************************************
* bl @dialog.append
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.append:
        .pushregs 1                 ; Push registers and return address on stack
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.append.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.append
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.append
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.append
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog
        
        li    tmp0,txt.hint.append2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint
        li    tmp0,txt.keys.insert
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.append.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
        li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
        mov   *tmp0,tmp1            ; Anything set?
        jeq   dialog.append.cursor  ; No default filename, skip

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.append.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser     ; Show file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.append.exit:
        .popregs 1                  ; Pop registers and return to caller

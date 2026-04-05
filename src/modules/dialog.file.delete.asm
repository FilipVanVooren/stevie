* FILE......: dialog.file.delete.asm
* Purpose...: Dialog "Delete File"

***************************************************************
* dialog.delete
* Delete "Delete file"
***************************************************************
* bl @dialog.delete
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
dialog.delete:
        .pushregs 1                 ; Push registers and return address on stack
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.delete.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.delete
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.delete
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.delete
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.hint.delete2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.delete.keylist:
        li    tmp0,txt.keys.default1
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set filename (1) 
        ;-------------------------------------------------------
dialog.delete.set.filename1:
        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @tv.devpath = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        li    tmp0,cat.fullfname
        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        jmp   dialog.delete.cursor  ; Set cursor shape
        ;-------------------------------------------------------
        ; Set filename (2) 
        ;-------------------------------------------------------
dialog.delete.set.filename2:
        li    tmp0,edb.filename      ; Set filename
        jeq   dialog.delete.clearcmd ; No filename to set

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        jmp   dialog.delete.cursor  ; Set cursor shape
        ;------------------------------------------------------
        ; Clear filename
        ;------------------------------------------------------
dialog.delete.clearcmd:        
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.delete.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser     ; Show file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.delete.exit:
        .popregs 1                  ; Pop registers and return to caller

* FILE......: dialog.file.open.asm
* Purpose...: Dialog "Open File"

***************************************************************
* dialog.open
* Dialog "Open file"
***************************************************************
* bl @dialog.open
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.open:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0       ; Editor dirty?
        jeq   dialog.open.setup     ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   dialog.open.exit      ; Exit early
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.open.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.open
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.open
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.open
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.hint.open2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.open2   ; Highlight FastMode
        jmp   dialog.open.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.open
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.open.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set filename (1) 
        ;-------------------------------------------------------
dialog.open.set.filename1:
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
        jmp   dialog.open.cursor    ; Set cursor shape
        ;-------------------------------------------------------
        ; Set filename (2) 
        ;-------------------------------------------------------
dialog.open.set.filename2:
        li    tmp0,edb.filename     ; Set filename
        jeq   dialog.open.clearcmd  ; No filename to set

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        jmp   dialog.open.cursor    ; Set cursor shape
        ;------------------------------------------------------
        ; Clear filename
        ;------------------------------------------------------
dialog.open.clearcmd:        
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.open.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser     ; Show file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.open.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

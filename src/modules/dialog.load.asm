* FILE......: dialog.load.asm
* Purpose...: Dialog "Load DV80 file"

***************************************************************
* dialog.load
* Open Dialog for loading DV 80 file
***************************************************************
* bl @dialog.load
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
dialog.load:
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
        jeq   dialog.load.setup     ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   dialog.load.exit      ; Exit early
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.load.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.load
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.load
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.load
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.hint.load2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.load2   ; Highlight FastMode
        jmp   dialog.load.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.load
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.load.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set filename (1) 
        ;-------------------------------------------------------
dialog.load.set.filename1:
        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
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
        jmp   dialog.load.cursor    ; Set cursor shape
        ;-------------------------------------------------------
        ; Set filename (2) 
        ;-------------------------------------------------------
dialog.load.set.filename2:
        li    tmp0,edb.filename     ; Set filename
        jeq   dialog.load.clearcmd  ; No filename to set

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        jmp   dialog.load.cursor    ; Set cursor shape
        ;------------------------------------------------------
        ; Clear filename
        ;------------------------------------------------------
dialog.load.clearcmd:        
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.load.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser     ; Show file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.load.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

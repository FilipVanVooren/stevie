* FILE......: dialog.file.run.asm
* Purpose...: Dialog "Run program image (EA5)"

***************************************************************
* dialog.run
* Dialog "Run program image (EA5)"
***************************************************************
* bl @dialog.run
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
dialog.run:
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
        jeq   dialog.run.setup      ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   dialog.run.exit       ; Exit early
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.run.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.run
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        clr   @cmdb.panhint2        ; No info message
        clr   @cmdb.panmarkers      ; No letter markers

        li    tmp0,txt.head.run
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.run
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.hint.run2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.run2    ; Highlight FastMode
        jmp   dialog.run.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.run
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.run.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set filename (1) 
        ;-------------------------------------------------------
dialog.run.set.filename1:
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
        jmp   dialog.run.cursor     ; Set cursor shape
        ;-------------------------------------------------------
        ; Set filename (2) 
        ;-------------------------------------------------------
dialog.run.set.filename2:
        li    tmp0,edb.filename     ; Set filename
        jeq   dialog.run.clearcmd   ; No filename to set

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        jmp   dialog.run.cursor     ; Set cursor shape
        ;------------------------------------------------------
        ; Clear filename
        ;------------------------------------------------------
dialog.run.clearcmd:        
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.run.cursor:
        bl      @pane.cursor.hide   ; No cursor at this time

        bl    @pane.cursor.blink  ; Show cursor
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser   ; Show file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.run.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

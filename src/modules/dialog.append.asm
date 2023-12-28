* FILE......: dialog.append.asm
* Purpose...: Dialog "Append DV80 file"

***************************************************************
* dialog.append
* Open Dialog for inserting DV 80 file
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
* tmp0, tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.append:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
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
        clr   @cmdb.panhint2        ; No extra hint to display

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.insert  ; Highlight FastMode
        jmp   dialog.append.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.insert
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
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Show file browser
        ;-------------------------------------------------------
        bl    @pane.filebrowser     ; Show file browser

        bl    @pane.filebrowser.hilight
                                    ; Show filename marker
                                    ; \ @i @cat.fpicker.idx = 1st file to show 
                                    ; /                       in file browser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.append.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

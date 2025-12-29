* FILE......: dialog.insert.asm
* Purpose...: Dialog "Insert DV80 file"

***************************************************************
* dialog.insert
* Open Dialog for inserting DV 80 file
***************************************************************
* bl @dialog.insert
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
dialog.insert:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Skip dialog if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor locked?
        jne   dialog.insert.exit    ; yes, skip dialog
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.insert.setup:
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.insert
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        ;------------------------------------------------------
        ; Include line number in pane header
        ;------------------------------------------------------
        bl    @film
              data cmdb.panhead.buf,>00,50
                                    ; Clear pane header buffer

        bl    @cpym2m
              data txt.head.insert,cmdb.panhead.buf,25

        mov   @fb.row,@parm1        ; Get row at cursor
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inct  @outparm1             ; \ Add base 1 and insert at line
                                    ; / following cursor, not line at cursor.

        bl    @mknum                ; Convert integer to string
              data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
              data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
              byte  48              ; | i  p2 = MSB offset for ASCII digit
              byte  48              ; / i  p2 = LSB char for replacing leading 0

        bl    @cpym2m
              data rambuf,cmdb.panhead.buf + 24,5
                                    ; Add line number to buffer

        li    tmp0,29
        sla   tmp0,8
        movb  tmp0,@cmdb.panhead.buf ; Set length byte

        li    tmp0,cmdb.panhead.buf
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        ;------------------------------------------------------
        ; Other panel strings
        ;------------------------------------------------------
        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.insert
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.hint.insert2
        mov   tmp0,@cmdb.panhint2   ; Show extra hint

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.insert  ; Highlight FastMode
        jmp   dialog.insert.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.insert
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.insert.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
        li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
        mov   *tmp0,tmp1            ; Anything set?
        jeq   dialog.insert.cursor  ; No default filename, skip

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.insert.cursor:
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
dialog.insert.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

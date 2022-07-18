* FILE......: dialog.clipboard.asm
* Purpose...: Dialog "Insert snippet from clipboard"

***************************************************************
* dialog.clipboard
* Open Dialog for inserting snippet from clipboard
***************************************************************
* bl @dialog.clipboard
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
dialog.clipboard:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.clipboard.setup:
        li    tmp0,id.dialog.clipboard
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        ;------------------------------------------------------
        ; Include line number in pane header
        ;------------------------------------------------------
        bl    @film
              data cmdb.panhead.buf,>00,50
                                    ; Clear pane header buffer

        bl    @cpym2m
              data txt.head.clipboard,cmdb.panhead.buf,27

        mov   @fb.row,@parm1
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inc   @outparm1             ; Add base 1

        bl    @mknum                ; Convert integer to string
              data  outparm1        ; \ i  p0 = Pointer to 16 bit unsigned int
              data  rambuf          ; | i  p1 = Pointer to 5 byte string buffer
              byte  48              ; | i  p2 = MSB offset for ASCII digit
              byte  48              ; / i  p2 = LSB char for replacing leading 0

        bl    @cpym2m
              data rambuf,cmdb.panhead.buf + 27,5
                                    ; Add line number to buffer

        li    tmp0,32
        sla   tmp0,8
        movb  tmp0,@cmdb.panhead.buf
                                    ; Set length byte

        li    tmp0,cmdb.panhead.buf
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        ;------------------------------------------------------
        ; Other panel strings
        ;------------------------------------------------------
        li    tmp0,txt.hint.clipboard
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.info.clipboard
        mov   tmp0,@cmdb.paninfo    ; Show info message

        clr   @cmdb.panmarkers      ; No key markers

        bl    @cmdb.cmd.clear       ; Clear current command

        abs   @fh.offsetopcode      ; FastMode is off ?
        jeq   !
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.clipboard ; Highlight FastMode
        jmp   dialog.clipboard.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.clipboard
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.clipboard.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.clipboard.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: dialog.save.asm
* Purpose...: Dialog "Save DV80 file"

***************************************************************
* dialog.save
* Dialog "Save"
***************************************************************
* bl @dialog.save
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
dialog.save:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Crunch current row if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   !                     ; Skip crunching if clean
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
!       c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   dialog.save.default   ; Yes, so show default dialog
        ;-------------------------------------------------------
        ; Setup dialog title
        ;-------------------------------------------------------
        bl    @cmdb.cmd.clear       ; Clear current CMDB command

        li    tmp0,id.dialog.saveblock
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.save2   ; Title "Save block to file"
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        jmp   dialog.save.header
        ;-------------------------------------------------------
        ; Default dialog
        ;-------------------------------------------------------
dialog.save.default:
        li    tmp0,id.dialog.save
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.save    ; Title "Save file"
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
        li    tmp0,edb.filename     ; Set filename
        mov   tmp0,@parm1           ; Get pointer to string

        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Setup header
        ;-------------------------------------------------------
dialog.save.header:
        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.save
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.save
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        clr   @fh.offsetopcode      ; Data buffer in VDP RAM
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
        bl    @pane.cursor.blink    ; Show cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.save.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

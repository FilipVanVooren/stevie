* FILE......: dialog.save.asm
* Purpose...: Dialog "Save file"

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Save DV80 file
*//////////////////////////////////////////////////////////////


***************************************************************
* dialog.save
* Open Dialog for saving file
***************************************************************
* b @dialog.save
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
!       li    tmp0,id.dialog.save
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.save
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.save
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.save
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        clr   @fh.offsetopcode      ; Data buffer in VDP RAM

        bl    @pane.cursor.blink    ; Show cursor

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
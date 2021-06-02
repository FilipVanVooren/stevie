* FILE......: dialog.save.asm
* Purpose...: Dialog "Save DV80 file"

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
        li    tmp0,txt.head.save2   ; Title "Save code block to DV80 file"                

        jmp   dialog.save.header
        ;-------------------------------------------------------
        ; Default dialog
        ;-------------------------------------------------------
dialog.save.default:        
        li    tmp0,id.dialog.save
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.save    ; Title "Save DV80 file"
        ;-------------------------------------------------------
        ; Setup header
        ;-------------------------------------------------------
dialog.save.header:
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt

        li    tmp0,txt.hint.save
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.save
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        clr   @fh.offsetopcode      ; Data buffer in VDP RAM
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2 
                                    ; Get cursor shape and color        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.save.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
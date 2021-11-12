* FILE......: dialog.print.asm
* Purpose...: Dialog "Print file"

***************************************************************
* dialog.print
* Open Dialog for printing file
***************************************************************
* b @dialog.print
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
dialog.print:
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
        jeq   dialog.print.default  ; Yes, so show default dialog
        ;-------------------------------------------------------
        ; Setup dialog title
        ;-------------------------------------------------------
        bl    @cmdb.cmd.clear       ; Clear current CMDB command

        li    tmp0,id.dialog.printblock
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.print2  ; Title "Print block to file"                

        jmp   dialog.save.header
        ;-------------------------------------------------------
        ; Default dialog
        ;-------------------------------------------------------
dialog.print.default:        
        li    tmp0,id.dialog.print
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.print   ; Title "Print file"
        ;-------------------------------------------------------
        ; Setup header
        ;-------------------------------------------------------
dialog.print.header:
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers        

        li    tmp0,txt.hint.print
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
dialog.print.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
* FILE......: dialog.print.asm
* Purpose...: Dialog "Print file"

***************************************************************
* dialog.print
* Dialog "Print"
***************************************************************
* bl @dialog.print
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
        li    tmp0,id.dialog.printblock
        mov   tmp0,@cmdb.dialog     ; Set dialog ID
        li    tmp0,txt.head.print2  ; Title "Print block to file"

        jmp   dialog.print.header
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
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.keys.save1
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        clr   @fh.offsetopcode      ; Data buffer in VDP RAM
        ;-------------------------------------------------------
        ; Line termination on ?
        ;-------------------------------------------------------
        mov   @edb.lineterm,tmp0    ; Get line termination mode + char
        andi  tmp0,>ff00            ; Only interested in MSB
        jeq   !                     ; Line termination mode is off
        ;-------------------------------------------------------
        ; Line termination on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.save2
        jmp   dialog.print.cmdline
        ;-------------------------------------------------------
        ; Line termination off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.save1        
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
dialog.print.cmdline:        
        li    tmp0,tv.printer.fname ; Set printer name
        mov   tmp0,@parm1           ; Get pointer to string

        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
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

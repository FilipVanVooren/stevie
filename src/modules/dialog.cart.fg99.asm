* basic......: dialog.cart.fg99.asm
* Purpose....: Dialog "Final GROM 99"

***************************************************************
* dialog.cart.fg99
* Open Dialog "Final GROM 99"
***************************************************************
* bl @dialog.cart.fg99
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
dialog.cart.fg99:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0        ; Editor dirty?
        jeq   dialog.cart.fg99.setup ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   dialog.cart.fg99.exit ; Exit early
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.cart.fg99.setup:        
        li    tmp0,id.dialog.cart.fg99
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.cart.fg99
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; Show input prompt
        clr   @cmdb.panmarkers      ; Hide letter markers
 
        li    tmp0,txt.hint.cart.fg992 
        mov   tmp0,@cmdb.panhint2   ; Show extra hint

        li    tmp0,txt.hint.cart.fg99
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.cart.fg99
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.blink    ; Blink cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.cart.fg99.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

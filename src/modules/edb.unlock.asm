* FILE......: edb.unlock.asm
***************************************************************
* edb.lock
* Unlock editor buffer for changes
***************************************************************
*  bl   @edb.unlock
*--------------------------------------------------------------
* INPUT
* @edb.locked = Editor buffer locked flag
*--------------------------------------------------------------
* OUTPUT
* None
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Memory usage
********|*****|*********************|**************************
edb.unlock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jeq   edb.unlock.exit       ; No, exit
        clr   @edb.locked           ; Clear lock flag
        ;-------------------------------------------------------
        ; Show message 'Editor unlocked'
        ;-------------------------------------------------------
        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @putat
              byte 0,52
              data txt.unlocked     ; Display message

        mov   *stack+,@wyx          ; Restore cursor position
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edb.unlock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11
        b     *r11                  ; Return

txt.unlocked:
        stri "Editor unlocked"      ; Text for unlocked message
        even

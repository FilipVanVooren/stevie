* FILE......: edb.lock.asm
***************************************************************
* edb.lock
* Lock editor buffer to prevent accidental changes
***************************************************************
*  bl   @edb.lock
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
edb.lock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Set lock flag
        ;-------------------------------------------------------
        seto  @edb.locked           ; Set lock flag
        clr   @edb.autoinsert       ; Clear auto insert flag
        ;-------------------------------------------------------
        ; Show message 'Editor locked'
        ;-------------------------------------------------------
        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @putat
              byte 0,52
              data txt.locked       ; Display lock message

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
edb.lock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11
        b     *r11                  ; Return

txt.locked:
        stri "Editor locked"        ; Text for locked message
        even

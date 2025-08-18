* FILE......: tv.linelen.toggle.asm
* Purpose...: Toggle line length display in status line


***************************************************************
* tv.linelen.toggle
* Toggle line length display in status line
***************************************************************
*  bl   @tv.linelen.toggle
*--------------------------------------------------------------
* INPUT
* @tv.show.linelen = Flag for tracking line length display
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
tv.linelen.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Toggle line length display
        ;-------------------------------------------------------
        bl    @hchar
              byte 0,50,32,20
              data EOL              ; Erase any previous message

        inv   @tv.show.linelen      ; Toggle line length display
        jeq   !
        ;-------------------------------------------------------
        ; Show message 'LineLength on'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.linelen.on   ; LineLength on
        jmp   tv.linelen.oneshot
        ;-------------------------------------------------------
        ; Show message 'LineLength off'
        ;-------------------------------------------------------
!       bl    @putat
              byte 0,52
              data txt.linelen.off  ; LineLength off
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
tv.linelen.oneshot:
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.linelen.toggle.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

txt.linelen.on     stri 'Line Length: ON'
                   even
txt.linelen.off    stri 'Line Length: OFF'
                   even
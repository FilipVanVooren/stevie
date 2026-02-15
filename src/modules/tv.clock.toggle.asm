* FILE......: tv.clock.toggle.asm
* Purpose...: Toggle line length display in status line


***************************************************************
* tv.clock.toggle
* Toggle clock display in status line
***************************************************************
*  bl   @tv.clock.toggle
*--------------------------------------------------------------
* INPUT
* @tv.clock.state = Flag for tracking clock display
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
tv.clock.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Toggle clock display
        ;-------------------------------------------------------
        bl    @hchar
              byte 0,50,32,20
              data EOL              ; Erase any previous message

        inv   @tv.clock.state       ; Toggle clock display
        jeq   !
        ;-------------------------------------------------------
        ; Show message 'Clock: ON'
        ;-------------------------------------------------------
        bl    @tv.clock.start       ; Start clock reading task
        bl    @putat
              byte 0,52
              data txt.clock.on     ; clock on
        jmp   tv.clock.oneshot
        ;-------------------------------------------------------
        ; Show message 'Clock: OFF'
        ;-------------------------------------------------------
!       bl    @putat
              byte 0,52
              data txt.clock.off    ; clock off

        bl    @clslot
              data 1                ; Clear clock task (slot 1)
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
tv.clock.oneshot:
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.clock.toggle.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

txt.clock.on       stri 'Clock: ON'
                   even
txt.clock.off      stri 'Clock: OFF'
                   even

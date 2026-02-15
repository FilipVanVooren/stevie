* FILE......: fm.clock.off.asm
* Purpose...: Turn clock functionality off

***************************************************************
* fm.clock.off
* Turn clock functionality off
***************************************************************
* bl  @fm.clock.off
*--------------------------------------------------------------
* INPUT
* @parm1 = >0000 clock off message,
*          >ffff clock not found message
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
fm.clock.off:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2        
        ;------------------------------------------------------
        ; Reset clock
        ;------------------------------------------------------
        bl    @clslot               ; Stop clock task
              data 1

        bl    @film                 ; Clear clock structure
              data  fh.clock.datetime,>00,19
        ;------------------------------------------------------
        ; Determine message
        ;------------------------------------------------------
        mov   @tv.clock.state,tmp0  ; Is clock on?
        jeq   fm.clock.off.exit     ; No, exit early

        dect  stack
        mov   @wyx,*stack           ; Save cursor position
        ci    tmp0,>dead            ; No clock device found?
        jeq   !                     ; Yes, show clock not found     
        ;-------------------------------------------------------
        ; Clock: OFF
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.clockoff     ; Display clock off message
        mov   *stack+,@wyx          ; Restore cursor position
        jmp   fm.clock.off.oneshot
        ;-------------------------------------------------------
        ; Clock: Not found
        ;-------------------------------------------------------
!       bl    @tv.flash.screen      ; Flash screen to draw attention to message

        bl    @putat
              byte 0,52
              data txt.noclock      ; Display No clock found message
        mov   *stack+,@wyx          ; Restore cursor position              
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
fm.clock.off.oneshot:
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        clr   @tv.clock.state        ; Clear clock display flag
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.clock.off.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return


txt.clockoff:
        stri "Clock: OFF"           ; Text for clock off message
        even

txt.noclock:
        stri "Clock: not found!"    ; Text for clock device not found message
        even

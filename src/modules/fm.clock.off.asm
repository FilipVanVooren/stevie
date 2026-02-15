* FILE......: fm.clock.off.asm
* Purpose...: Turn clock functionality off

***************************************************************
* fm.clock.off
* Turn clock functionaltiy off
***************************************************************
* bl  @fm.clock.off
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
        ;-------------------------------------------------------
        ; Show message 'Clock: OFF'
        ;-------------------------------------------------------
        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @putat
              byte 0,52
              data txt.clockoff     ; Display clock off message

        mov   *stack+,@wyx          ; Restore cursor position              
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay        
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

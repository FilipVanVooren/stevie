* FILE......: fm.clock.on.asm
* Purpose...: Turn clock functionality on

***************************************************************
* fm.clock.on
* Turn clock functionaltiy on
***************************************************************
* bl  @fm.clock.on
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fm.clock.on:
        .pushregs 2                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Reset clock
        ;------------------------------------------------------
        bl    @tv.clock.start       ; Start clock task        
        ;-------------------------------------------------------
        ; Show message 'Clock: ON'
        ;-------------------------------------------------------
        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @putat
              byte 0,52
              data txt.clockon      ; Display clock on message

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
fm.clock.on.exit:
        .popregs 2                  ; Pop registers and return to caller                


txt.clockon:
        stri "Clock: ON"            ; Text for clock on message
        even

* FILE......: tv.clock.start.asm
* Purpose...: Setup clock reading task

***************************************************************
* tv.clock.start
* Setup clock reading task
***************************************************************
* bl  @tv.clock.start
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
tv.clock.start:
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
        bl    @film                 ; Clear clock structure
              data  fh.clock.datetime,>00,19
        ;------------------------------------------------------
        ; Fast clock reading task
        ;------------------------------------------------------
        bl    @mkslot               ; Setup Task Scheduler slots         
              data >017f,task.clock ; \ Task 1 - Read clock device
              data eol              ; / approx. every 1 second
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.clock.start.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

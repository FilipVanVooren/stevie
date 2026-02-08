* FILE......: task.clock.asm
* Purpose...: Read clock device task

***************************************************************
* Task - Read date/time from clock device
***************************************************************
task.clock:
        dect  stack
        mov   r11,*stack            ; Save return address  
        ;------------------------------------------------------
        ; Read date/time from clock device and display
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank5.rom        ; | i  p0 = bank address
              data vec.25           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return 
        ;------------------------------------------------------
        ; Adjust clock rate
        ;------------------------------------------------------
        mov   @cmdb.visible,tmp0    ; Is CMDB visible?
        jeq   task.clock.slow       ; No, use slow clock reading task
        ;------------------------------------------------------
        ; Fast clock reading task
        ;------------------------------------------------------
task.clock.fast:
        bl    @mkslot               ; Setup Task Scheduler slots         
              data >0132,task.clock ; \ Task 1 - Read clock device
              data eol              ; / approx. every 1 second
        jmp   task.clock.exit       ; Exit task
        ;------------------------------------------------------
        ; Slow clock reading task
        ;------------------------------------------------------
task.clock.slow:
        bl    @mkslot               ; Setup Task Scheduler slots         
              data >0160,task.clock ; \ Task 1 - Read clock device
              data eol              ; / approx. every 1.5 seconds   
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.clock.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task

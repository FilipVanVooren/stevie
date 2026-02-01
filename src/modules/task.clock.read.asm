* FILE......: task.clock.read.asm
* Purpose...: Read clock device task

***************************************************************
* Task - Read date/time from clock device
***************************************************************
task.clock.read:
        dect  stack
        mov   r11,*stack            ; Save return address  
        ;------------------------------------------------------
        ; Read date/time from clock device and display
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.31           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return  
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.clock.read.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task

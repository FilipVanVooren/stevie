* FILE......: task.vdp.cursor.asm
* Purpose...: VDP cursor shape

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set cursor shape
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data vec.5            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return  
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task

* FILE......: task.vdp.cursor.char.asm
* Purpose...: VDP cursor shape (character version)

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set cursor shape (character version)
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

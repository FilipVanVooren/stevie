* FILE......: rom.stubs.bank4_extra.asm
* Purpose...: Small extra stubs required by bank4 before other stubs

***************************************************************
* Forward stub for "vdp.cursor.tat.fb"
* bank6 vec.4
********|*****|*********************|**************************
vdp.cursor.tat.fb:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 6
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data vec.4            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

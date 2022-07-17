* FILE......: rom.stubs.bank4.asm
* Purpose...: Bank 4 stubs for functions in other banks

***************************************************************
* Stub for "fb.refresh"
* bank1 vec.20
********|*****|*********************|**************************
fb.refresh:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.20           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

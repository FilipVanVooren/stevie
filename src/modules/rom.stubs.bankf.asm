* FILE......: rom.stubs.bankf.asm
* Purpose...: Bank F stubs for functions in other banks

***************************************************************
* Stub for "fh.file.load.bin"
* bank2 vec.15
********|*****|*********************|**************************
fh.file.load.bin:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.15           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

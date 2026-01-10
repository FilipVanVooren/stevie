* FILE......: rom.stubs.bank6.asm
* Purpose...: Bank 6 stubs for functions in other banks


***************************************************************
* Stub for "pane.colorscheme.index"
* bank4 vec.43
********|*****|*********************|**************************
pane.colorscheme.index:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.43           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "edb.block.match"
* bank5 vec.12
********|*****|*********************|**************************
edb.block.match:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank5.rom        ; | i  p0 = bank address
              data vec.12           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

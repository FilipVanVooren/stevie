* FILE......: rom.stubs.bank7.asm
* Purpose...: Bank 7 stubs for functions in other banks

***************************************************************
* Stub for "pane.action.colorscheme.load"
* bank1 vec.31
********|*****|*********************|**************************
pane.action.colorscheme.load:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.31           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller            

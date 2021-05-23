* FILE......: rom.stubs.bank3.asm
* Purpose...: Bank 3 stubs for functions in other banks

***************************************************************
* Stub for "edb.line.pack"
* bank1 vec.10
********|*****|*********************|**************************
edb.line.pack:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller              


***************************************************************
* Stub for "edkey.action.cmdb.show"
* bank1 vec.15
********|*****|*********************|**************************
edkey.action.cmdb.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.15           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller     


***************************************************************
* Stub for "cmdb.cmd.clear"
* bank1 vec.19
********|*****|*********************|**************************
cmdb.cmd.clear:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.19           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller     


***************************************************************
* Stub for "pane.cursor.blink"
* bank1 vec.28
********|*****|*********************|**************************
pane.cursor.blink:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.28           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller         

***************************************************************
* Stub for "pane.cursor.hide"
* bank1 vec.29
********|*****|*********************|**************************
pane.cursor.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.29           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller             
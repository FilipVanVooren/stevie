* FILE......: rom.stubs.bankx.asm
* Purpose...: Stubs to include in all banks (with exceptions)


 .ifgt bankid,bank1.rom
***************************************************************
* Stub for "mem.sams.setup.stevie"
* Exclude: bank0, bank1
* bank1 vec.1
********|*****|*********************|**************************
mem.sams.setup.stevie:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
 .endif

 
 .ifgt bankid,bank0.rom
 .ifne bankid,bank7.rom

***************************************************************
* Stub for "mem.sams.set.legacy"
* bank7 vec.1
********|*****|*********************|**************************
mem.sams.set.legacy:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
 

***************************************************************
* Stub for "mem.sams.set.boot"
* Exclude: bank0, bank7
* bank7 vec.2
********|*****|*********************|**************************
mem.sams.set.boot:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "mem.sams.set.stevie"
* bank7 vec.3
********|*****|*********************|**************************
mem.sams.set.stevie:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.3            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

 .endif
 .endif

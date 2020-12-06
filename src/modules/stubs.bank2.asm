* FILE......: stubs.bank2.asm
* Purpose...: Bank 2 stubs for functions in other banks

***************************************************************
* Stub for "idx.entry.update"
* bank1 vec.2
********|*****|*********************|**************************
idx.entry.update:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11        
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "idx.pointer.get"
* bank1 vec.4
********|*****|*********************|**************************
idx.pointer.get:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.4            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                



***************************************************************
* Stub for "edb.line.unpack"
* bank1 vec.11
********|*****|*********************|**************************
edb.line.unpack:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.11           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                        


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
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.20           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                              



***************************************************************
* Stub for "fb.vdpdump"
* bank1 vec.21
********|*****|*********************|**************************
fb.vdpdump:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.21           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                              




***************************************************************
* Stub for "pane.errline.show"
* bank1 vec.30
********|*****|*********************|**************************
pane.errline.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.30           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller      


***************************************************************
* Stub for "pane.action.colorscheme.load"
* bank1 vec.31
********|*****|*********************|**************************
pane.action.colorscheme.load
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.31           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                   


***************************************************************
* Stub for "pane.action.colorscheme.statuslines"
* bank1 vec.32
********|*****|*********************|**************************
pane.action.colorscheme.statlines
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank1            ; | i  p0 = bank address
              data vec.32           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller                   
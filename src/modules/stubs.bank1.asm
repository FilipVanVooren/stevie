* FILE......: stubs.bank1.asm
* Purpose...: Stubs for functions in other banks


***************************************************************
* Stub for "About dialog"
********|*****|*********************|**************************
edkey.action.about:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rb.farjump           ; \ Trampoline jump to bank
              data bank2            ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane                

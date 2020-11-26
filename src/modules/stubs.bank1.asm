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
        bl    @swbnk                ; \ Trampoline jump to bank
              data bank2,vector.1   ; | i  p0 = bank address
                                    ; / i  p1 = Target address in bank
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane                

* FILE......: rom.stubs.bank1.asm
* Purpose...: Bank 1 stubs for functions in other banks

***************************************************************
* Stub for "fm.loadfile"
* bank2 vec.1
********|*****|*********************|**************************
fm.loadfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2            ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Show "Unsaved changes" dialog if editor buffer dirty
        ;------------------------------------------------------ 
        mov   @outparm1,tmp0
        jeq   fm.loadfile.exit

        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     @dialog.unsaved       ; Show dialog and exit
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.exit:        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fm.savefile"
* bank2 vec.2
********|*****|*********************|**************************
fm.savefile:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------        
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2            ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "About dialog"
* bank3 vec.1
********|*****|*********************|**************************
edkey.action.about:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3            ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Stub for "Load DV80 file"
* bank3 vec.2
********|*****|*********************|**************************
dialog.load:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3            ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Stub for "Save DV80 file"
* bank3 vec.3
********|*****|*********************|**************************
dialog.save:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3            ; | i  p0 = bank address
              data vec.3            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Stub for "Unsaved Changes"
* bank3 vec.4
********|*****|*********************|**************************
dialog.unsaved:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3            ; | i  p0 = bank address
              data vec.4            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane




***************************************************************
* Stub for Dialog "Move/Copy/Delete block"
* bank3 vec.5
********|*****|*********************|**************************
dialog.block:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3            ; | i  p0 = bank address
              data vec.5            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Stub for "fb.tab.next"
* bank4 vec.1
********|*****|*********************|**************************
fb.tab.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Put cursor on next tab position
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4            ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

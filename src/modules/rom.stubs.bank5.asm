* FILE......: rom.stubs.bank5.asm
* Purpose...: Bank 5 stubs for functions in other banks

***************************************************************
* Trampoline bank 1 with return
********|*****|*********************|**************************
_trampoline.bank1.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank1.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "tv.clock.start"
* bank1 vec.3
********|*****|*********************|**************************
tv.clock.start:
        mov   @tv.clock.start.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
tv.clock.start.vector:
        data  vec.3

***************************************************************
* Stub for "edb.line.unpack"
* bank1 vec.11
********|*****|*********************|**************************
edb.line.unpack:
        mov   @edb.line.unpack.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edb.line.unpack.vector:
        data  vec.11

***************************************************************
* Stub for "fb.vdpdump"
* bank1 vec.21
********|*****|*********************|**************************
fb.vdpdump:
        mov   @fb.vdpdump.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
fb.vdpdump.vector:
        data  vec.21

***************************************************************
* Stub for "pane.errline.show"
* bank1 vec.30
********|*****|*********************|**************************
pane.errline.show:
        mov   @pane.errline.show.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
pane.errline.show.vector:
        data  vec.30

***************************************************************
* Trampoline bank 2 with return
********|*****|*********************|**************************
_trampoline.bank2.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "fm.savefile"
* bank2 vec.4
********|*****|*********************|**************************
fm.savefile:
        mov   @fm.savefile.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
fm.savefile.vector:
        data  vec.4

***************************************************************
* Trampoline bank 4 with return
********|*****|*********************|**************************
_trampoline.bank4.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 4
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "fb.refresh"
* bank4 vec.8
********|*****|*********************|**************************
fb.refresh:
        mov   @fb.refresh.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.refresh.vector:
        data  vec.8

***************************************************************
* Stub for "fb.goto.nextmatch"
* bank4 vec.23
********|*****|*********************|**************************
fb.goto.nextmatch:
        mov   @fb.goto.nextmatch.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.goto.nextmatch.vector:
        data  vec.23

***************************************************************
* Stub for "pane.botline.busy.on"
* bank4 vec.38
********|*****|*********************|**************************
pane.botline.busy.on:
        mov   @pane.botline.busy.on.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.busy.on.vector:
        data  vec.38

***************************************************************
* Stub for "pane.botline.busy.off"
* bank4 vec.39
********|*****|*********************|**************************
pane.botline.busy.off:
        mov   @pane.botline.busy.off.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.busy.off.vector:
        data  vec.39

***************************************************************
* Stub for "pane.colorscheme.load"
* bank4 vec.41
********|*****|*********************|**************************
pane.colorscheme.load:
        mov   @pane.colorscheme.load.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.colorscheme.load.vector:
        data  vec.41

***************************************************************
* Stub for "pane.colorscheme.botline"
* bank4 vec.42
********|*****|*********************|**************************
pane.colorscheme.botline:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 1
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.42           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "pane.cmdb.hide"
* bank4 vec.49
********|*****|*********************|**************************
pane.cmdb.hide:
        mov   @pane.cmdb.hide.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.cmdb.hide.vector:
        data  vec.49

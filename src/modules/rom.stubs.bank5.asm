* FILE......: rom.stubs.bank5.asm
* Purpose...: Bank 5 stubs for functions in other banks
*
* GENERATED FILE - DO NOT EDIT. Content and block order are derived
* from build/vector-registry.txt; edit the registry (or re-run
* 'gen_vectors.py extract' after moving code) and regenerate with:
*     python3 build/tools/gen_vectors.py generate
* The build aborts on drift ('gen_vectors.py check'). Exception that
* stays hand-written: rom.stubs.bankx.asm (conditional SAMS stubs).

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
* bank1 vec.2
********|*****|*********************|**************************
tv.clock.start:
        mov   @tv.clock.start.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
tv.clock.start.vector:
        data  vec.2

***************************************************************
* Stub for "edb.line.unpack"
* bank1 vec.4
********|*****|*********************|**************************
edb.line.unpack:
        mov   @edb.line.unpack.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edb.line.unpack.vector:
        data  vec.4

***************************************************************
* Stub for "fb.vdpdump"
* bank1 vec.7
********|*****|*********************|**************************
fb.vdpdump:
        mov   @fb.vdpdump.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
fb.vdpdump.vector:
        data  vec.7

***************************************************************
* Stub for "pane.errline.show"
* bank1 vec.11
********|*****|*********************|**************************
pane.errline.show:
        mov   @pane.errline.show.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
pane.errline.show.vector:
        data  vec.11

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
* bank4 vec.7
********|*****|*********************|**************************
fb.refresh:
        mov   @fb.refresh.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.refresh.vector:
        data  vec.7

***************************************************************
* Stub for "fb.goto.nextmatch"
* bank4 vec.22
********|*****|*********************|**************************
fb.goto.nextmatch:
        mov   @fb.goto.nextmatch.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.goto.nextmatch.vector:
        data  vec.22

***************************************************************
* Stub for "pane.botline.busy.on"
* bank4 vec.28
********|*****|*********************|**************************
pane.botline.busy.on:
        mov   @pane.botline.busy.on.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.busy.on.vector:
        data  vec.28

***************************************************************
* Stub for "pane.botline.busy.off"
* bank4 vec.29
********|*****|*********************|**************************
pane.botline.busy.off:
        mov   @pane.botline.busy.off.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.busy.off.vector:
        data  vec.29

***************************************************************
* Stub for "pane.colorscheme.load"
* bank4 vec.31
********|*****|*********************|**************************
pane.colorscheme.load:
        mov   @pane.colorscheme.load.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.colorscheme.load.vector:
        data  vec.31

***************************************************************
* Stub for "pane.colorscheme.botline"
* bank4 vec.32
********|*****|*********************|**************************
pane.colorscheme.botline:
        mov   @pane.colorscheme.botline.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.colorscheme.botline.vector:
        data  vec.32

***************************************************************
* Stub for "pane.cmdb.hide"
* bank4 vec.36
********|*****|*********************|**************************
pane.cmdb.hide:
        mov   @pane.cmdb.hide.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.cmdb.hide.vector:
        data  bankx.exttab+6

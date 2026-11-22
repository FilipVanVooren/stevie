* FILE......: rom.stubs.bank2.asm
* Purpose...: Bank 2 stubs for functions in other banks
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
* Stub for "pane.cursor.blink"
* bank1 vec.28
********|*****|*********************|**************************
pane.cursor.blink:
        mov   @pane.cursor.blink.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
pane.cursor.blink.vector:
        data  vec.28

***************************************************************
* Stub for "pane.cursor.hide"
* bank1 vec.29
********|*****|*********************|**************************
pane.cursor.hide:
        mov   @pane.cursor.hide.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
pane.cursor.hide.vector:
        data  vec.29

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
        mov   @pane.colorscheme.botline.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.colorscheme.botline.vector:
        data  vec.42

***************************************************************
* Stub for "pane.cmdb.show"
* bank4 vec.59
********|*****|*********************|**************************
pane.cmdb.show:
        mov   @pane.cmdb.show.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.cmdb.show.vector:
        data  vec.59

***************************************************************
* Stub for "fb.cursor.top"
* bank4 vec.16
********|*****|*********************|**************************
fb.cursor.top:
        mov   @fb.cursor.top.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.top.vector:
        data  vec.16

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
* Stub for "pane.cmdb.hide"
* bank4 vec.49
********|*****|*********************|**************************
pane.cmdb.hide:
        mov   @pane.cmdb.hide.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.cmdb.hide.vector:
        data  vec.49

***************************************************************
* Stub for "pane.filebrowser"
* bank4 vec.50
********|*****|*********************|**************************
pane.filebrowser:
        mov   @pane.filebrowser.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.filebrowser.vector:
        data  vec.50

***************************************************************
* Stub for "pane.filebrowser.colbar"
* bank4 vec.52
********|*****|*********************|**************************
pane.filebrowser.colbar:
        mov   @pane.filebrowser.colbar.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.filebrowser.colbar.vector:
        data  vec.52

***************************************************************
* Stub for "pane.filebrowser.colbar.remove"
* bank4 vec.53
********|*****|*********************|**************************
pane.filebrowser.colbar.remove:
        mov   @pane.filebrowser.colbar.remove.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.filebrowser.colbar.remove.vector:
        data  vec.53

***************************************************************
* Trampoline bank 5 with return
********|*****|*********************|**************************
_trampoline.bank5.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 5
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank5.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "edb.clear.sams"
* bank5 vec.1
********|*****|*********************|**************************
edb.clear.sams:
        mov   @edb.clear.sams.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.clear.sams.vector:
        data  vec.1

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
* Stub for "edb.find.init"
* bank5 vec.15
********|*****|*********************|**************************
edb.find.init:
        mov   @edb.find.init.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.find.init.vector:
        data  vec.15

***************************************************************
* Stub for "edb.find.search"
* bank5 vec.16
********|*****|*********************|**************************
edb.find.search:
        mov   @edb.find.search.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.find.search.vector:
        data  vec.16

***************************************************************
* Stub for "fm.clock.off"
* bank5 vec.27
********|*****|*********************|**************************
fm.clock.off:
        mov   @fm.clock.off.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
fm.clock.off.vector:
        data  vec.27

***************************************************************
* Trampoline bank 6 with return
********|*****|*********************|**************************
_trampoline.bank6.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 6
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "vdp.dump.patterns"
* bank6 vec.1
********|*****|*********************|**************************
vdp.dump.patterns:
        mov   @vdp.dump.patterns.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.dump.patterns.vector:
        data  vec.1

***************************************************************
* Stub for "vdp.colors.line"
* bank6 vec.3
********|*****|*********************|**************************
vdp.colors.line:
        mov   @vdp.colors.line.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.colors.line.vector:
        data  vec.3

***************************************************************
* Stub for "vdp.cursor.tat.cmdb.hide"
* bank6 vec.6
********|*****|*********************|**************************
vdp.cursor.tat.cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 6
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data vec.6            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.tat.cmdb.hide.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "tv.set.font"
* bank6 vec.32
********|*****|*********************|**************************
tv.set.font:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 6
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data vec.32           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.set.font.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "tv.reset"
* bank7 vec.23
********|*****|*********************|**************************
tv.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 7
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.23           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.reset.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "mem.run.ea5"
* bank7 vec.12
********|*****|*********************|**************************
mem.run.ea5:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 7
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.12           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.run.ea5.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: rom.stubs.bank3.asm
* Purpose...: Bank 3 stubs for functions in other banks
*
* GENERATED FILE - DO NOT EDIT. Content and block order are derived
* from build/vector-registry.txt; edit the registry (or re-run
* 'gen_vectors.py extract' after moving code) and regenerate with:
*     python3 build/gen_vectors.py generate
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
* bank1 vec.3
********|*****|*********************|**************************
tv.clock.start:
        mov   @tv.clock.start.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
tv.clock.start.vector:
        data  vec.3

***************************************************************
* Stub for "edb.line.pack"
* bank1 vec.10
********|*****|*********************|**************************
edb.line.pack:
        mov   @edb.line.pack.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edb.line.pack.vector:
        data  vec.10

***************************************************************
* Stub for "edk.act.cmdb.show"
* bank1 vec.15
********|*****|*********************|**************************
edk.act.cmdb.show:
        mov   @edk.act.cmdb.show.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edk.act.cmdb.show.vector:
        data  vec.15

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
* Stub for "pane.errline.hide"
* bank1 vec.27
********|*****|*********************|**************************
pane.errline.hide:
        mov   @pane.errline.hide.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
pane.errline.hide.vector:
        data  vec.27

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
* Stub for "fm.directory"
* bank2 vec.6
********|*****|*********************|**************************
fm.directory:
        mov   @fm.directory.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
fm.directory.vector:
        data  vec.6

***************************************************************
* Stub for "fm.browse.fname.set"
* bank2 vec.12
********|*****|*********************|**************************
fm.browse.fname.set:
        mov   @fm.browse.fname.set.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
fm.browse.fname.set.vector:
        data  vec.12

***************************************************************
* Stub for "fm.clock.read"
* bank2 vec.14
********|*****|*********************|**************************
fm.clock.read:
        mov   @fm.clock.read.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
fm.clock.read.vector:
        data  vec.14

***************************************************************
* Stub for "fb.scan.fname"
* bank4 vec.5
********|*****|*********************|**************************
fb.scan.fname:
        mov   @fb.scan.fname.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.scan.fname.vector:
        data  vec.5

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
* Stub for "pane.botline.keycolor"
* bank4 vec.44
********|*****|*********************|**************************
pane.botline.keycolor:
        mov   @pane.botline.keycolor.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.keycolor.vector:
        data  vec.44

***************************************************************
* Stub for "error.display"
* bank4 vec.45
********|*****|*********************|**************************
error.display:
        mov   @error.display.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
error.display.vector:
        data  vec.45

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
* Stub for "pane.filebrowser.hilight"
* bank4 vec.51
********|*****|*********************|**************************
pane.filebrowser.hilight:
        mov   @pane.filebrowser.hilight.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.filebrowser.hilight.vector:
        data  vec.51

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
* Stub for "pane.clock.time"
* bank5 vec.25
********|*****|*********************|**************************
pane.clock.time:
        mov   @pane.clock.time.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
pane.clock.time.vector:
        data  vec.25

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
* Stub for "vdp.cursor.tat.fb"
* bank6 vec.4
********|*****|*********************|**************************
vdp.cursor.tat.fb:
        mov   @vdp.cursor.tat.fb.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.cursor.tat.fb.vector:
        data  vec.4

***************************************************************
* Trampoline bank E with return
********|*****|*********************|**************************
_trampoline.banke.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank E
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data banke.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "mem.sams.dialogs.on"
* banke vec.2
********|*****|*********************|**************************
mem.sams.dialogs.on:
        mov   @mem.sams.dialogs.on.vector,@trmpvector
        jmp   _trampoline.banke.ret ; Longjump
mem.sams.dialogs.on.vector:
        data  vec.2

***************************************************************
* Stub for "mem.sams.dialogs.off"
* banke vec.3
********|*****|*********************|**************************
mem.sams.dialogs.off:
        mov   @mem.sams.dialogs.off.vector,@trmpvector
        jmp   _trampoline.banke.ret ; Longjump
mem.sams.dialogs.off.vector:
        data  vec.3

***************************************************************
* Trampoline bank F with return
********|*****|*********************|**************************
_trampoline.bankf.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank F
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bankf.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "dialog.help.content"
* bankf vec.1
********|*****|*********************|**************************
dialog.help.content:
        mov   @dialog.help.content.vector,@trmpvector
        jmp   _trampoline.bankf.ret ; Longjump
dialog.help.content.vector:
        data  vec.1

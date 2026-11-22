* FILE......: rom.stubs.bank4.asm
* Purpose...: Bank 4 stubs for functions in other banks
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
* Stub for "edb.line.pack.fb"
* bank1 vec.10
********|*****|*********************|**************************
edb.line.pack.fb:
        mov   @edb.line.pack.fb.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edb.line.pack.fb.vector:
        data  vec.10

***************************************************************
* Stub for "edb.line.unpack.fb"
* bank1 vec.11
********|*****|*********************|**************************
edb.line.unpack.fb:
        mov   @edb.line.unpack.fb.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
edb.line.unpack.fb.vector:
        data  vec.11

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
* Trampoline bank 3 with return
********|*****|*********************|**************************
_trampoline.bank3.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in bank 3
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "pane.cmdb.draw"
* bank3 vec.22
********|*****|*********************|**************************
pane.cmdb.draw:
        mov   @pane.cmdb.draw.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.draw.vector:
        data  vec.22

***************************************************************
* Stub for "cmdb.refresh_prompt"
* bank3 vec.24
********|*****|*********************|**************************
cmdb.refresh_prompt:
        mov   @cmdb.refresh_prompt.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.refresh_prompt.vector:
        data  vec.24

***************************************************************
* Stub for "cmdb.cmd.cursor_eol"
* bank3 vec.29
********|*****|*********************|**************************
cmdb.cmd.cursor_eol:
        mov   @cmdb.cmd.cursor_eol.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.cursor_eol.vector:
        data  vec.29

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
* Stub for "vdp.colors.line"
* bank6 vec.3
********|*****|*********************|**************************
vdp.colors.line:
        mov   @vdp.colors.line.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.colors.line.vector:
        data  vec.3

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
* Stub for "vdp.cursor.tat"
* bank6 vec.5
********|*****|*********************|**************************
vdp.cursor.tat:
        mov   @vdp.cursor.tat.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.cursor.tat.vector:
        data  vec.5

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

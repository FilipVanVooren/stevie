* FILE......: rom.stubs.bank7.asm
* Purpose...: Bank 7 stubs for functions in other banks
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
* Stub for "cmdb.dialog.close"
* bank1 vec.18
********|*****|*********************|**************************
cmdb.dialog.close:
        mov   @cmdb.dialog.close.vector,@trmpvector
        jmp   _trampoline.bank1.ret ; Longjump
cmdb.dialog.close.vector:
        data  vec.18

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
* Stub for "fm.newfile"
* bank2 vec.5
********|*****|*********************|**************************
fm.newfile:
        mov   @fm.newfile.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
fm.newfile.vector:
        data  vec.5

***************************************************************
* Stub for "file.vmem"
* bank2 vec.32
********|*****|*********************|**************************
file.vmem:
        mov   @file.vmem.vector,@trmpvector
        jmp   _trampoline.bank2.ret ; Longjump
file.vmem.vector:
        data  vec.32

***************************************************************
* Stub for "edb.find.init"
* bank5 vec.15
********|*****|*********************|**************************
edb.find.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 5
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank5.rom        ; | i  p0 = bank address
              data vec.15           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

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
* Stub for "dialog.basic"
* bank3 vec.13
********|*****|*********************|**************************
dialog.basic:
        mov   @dialog.basic.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
dialog.basic.vector:
        data  vec.13

***************************************************************
* Stub for "cmdb.cmd.getlength"
* bank3 vec.26
********|*****|*********************|**************************
cmdb.cmd.getlength:
        mov   @cmdb.cmd.getlength.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.getlength.vector:
        data  vec.26

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

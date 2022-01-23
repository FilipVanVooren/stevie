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
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
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
* Stub for "fm.insertfile"
* bank2 vec.2
********|*****|*********************|**************************
fm.insertfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.insertfile.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


**************************************************************
* Stub for "fm.browse.fname.suffix"
* bank2 vec.3
********|*****|*********************|**************************
fm.browse.fname.suffix:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.3            ; | i  p1 = Vector with target address
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
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.4            ; | i  p1 = Vector with target address
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
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.5            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for dialog "Help"
* bank3 vec.1
********|*****|*********************|**************************
dialog.help.next:
        c     @w$0008,@cmdb.dialog.var
        jeq   !
        a     @w$0008,@cmdb.dialog.var
        jmp   dialog.help
!       clr   @cmdb.dialog.var
dialog.help:
        mov   @dialog.help.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.help.vector:
        data  vec.1


***************************************************************
* Stub for dialog "Load file"
* bank3 vec.2
********|*****|*********************|**************************
dialog.load:
        mov   @dialog.load.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.load.vector:
        data  vec.2


***************************************************************
* Stub for dialog "Save file"
* bank3 vec.3
********|*****|*********************|**************************
dialog.save:
        mov   @dialog.save.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.save.vector:
        data  vec.3


***************************************************************
* Stub for dialog "Insert file at line"
* bank3 vec.4
********|*****|*********************|**************************
dialog.insert:
        mov   @dialog.insert.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.insert.vector:
        data  vec.4


***************************************************************
* Stub for dialog "Print file"
* bank3 vec.5
********|*****|*********************|**************************
dialog.print:
        mov   @dialog.print.vector,@trmpvector
        jmp   _trampoline.bank3    ; Show dialog
dialog.print.vector:
        data  vec.5


***************************************************************
* Stub for dialog "File"
* bank3 vec.6
********|*****|*********************|**************************
dialog.file:
        mov   @dialog.file.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.file.vector:
        data  vec.6


***************************************************************
* Stub for dialog "Unsaved Changes"
* bank3 vec.7
********|*****|*********************|**************************
dialog.unsaved:
        clr   @cmdb.panmarkers      ; No key markers
        mov   @dialog.unsaved.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.unsaved.vector:
        data  vec.7


***************************************************************
* Stub for dialog "Copy clipboard to line ..."
* bank3 vec.8
********|*****|*********************|**************************
dialog.clipboard:
        mov   @dialog.clipboard.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.clipboard.vector:
        data  vec.8


***************************************************************
* Stub for dialog "Configure clipboard device"
* bank3 vec.9
********|*****|*********************|**************************
dialog.clipdev:
        mov   @dialog.clipdev.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.clipdev.vector:
        data  vec.9


***************************************************************
* Stub for dialog "Configure"
* bank3 vec.10
********|*****|*********************|**************************
dialog.config:
        mov   @dialog.config.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.config.vector:
        data  vec.10


***************************************************************
* Stub for dialog "Append file"
* bank3 vec.11
********|*****|*********************|**************************
dialog.append:
        mov   @dialog.append.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.append.vector:
        data  vec.11


***************************************************************
* Stub for dialog "Cartridge"
* bank3 vec.12
********|*****|*********************|**************************
dialog.cartridge:
        mov   @dialog.cartridge.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.cartridge.vector:
        data  vec.12


***************************************************************
* Stub for dialog "Basic"
* bank3 vec.13
********|*****|*********************|**************************
dialog.basic:
        mov   @dialog.basic.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.basic.vector:
        data  vec.13


***************************************************************
* Stub for dialog "Main Menu"
* bank3 vec.30
********|*****|*********************|**************************
dialog.menu:
        ;------------------------------------------------------
        ; Check if block mode is active
        ;------------------------------------------------------
        mov   @edb.block.m2,tmp0    ; \
        inc   tmp0                  ; | Skip if M2 unset (>ffff)
                                    ; /
        jeq   !                     : Block mode inactive, show dialog
        ;------------------------------------------------------
        ; Special treatment for block mode
        ;------------------------------------------------------
        b     @edkey.action.block.reset
                                    ; Reset block mode
        ;------------------------------------------------------
        ; Show dialog
        ;------------------------------------------------------
!       mov   @dialog.menu.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.menu.vector:
        data  vec.30



***************************************************************
* Trampoline 1 (bank 3, dialog)
********|*****|*********************|**************************
_trampoline.bank3:
        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Call routine in specified bank
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3.rom        ; | i  p0 = bank address
              data >ffff            ; | i  p1 = Vector with target address
                                    ; |         (deref @trmpvector)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Stub for "error.display"
* bank3 vec.18
********|*****|*********************|**************************
error.display:
        mov   @error.display.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
error.display.vector:
        data  vec.18


***************************************************************
* Stub for "pane.show_hintx"
* bank3 vec.19
********|*****|*********************|**************************
pane.show_hintx:
        mov   @pane.show_hintx.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
pane.show_hintx.vector:
        data  vec.19


***************************************************************
* Stub for "pane.cmdb.show"
* bank3 vec.20
********|*****|*********************|**************************
pane.cmdb.show:
        mov   @pane.cmdb.show.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.show.vector:
        data  vec.20


***************************************************************
* Stub for "pane.cmdb.hide"
* bank3 vec.21
********|*****|*********************|**************************
pane.cmdb.hide:
        mov   @pane.cmdb.hide.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.hide.vector:
        data  vec.21


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
* Stub for "cmdb.refresh"
* bank3 vec.24
********|*****|*********************|**************************
cmdb.refresh:
        mov   @cmdb.refresh.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.refresh.vector:
        data  vec.24


***************************************************************
* Stub for "cmdb.cmd.clear"
* bank3 vec.25
********|*****|*********************|**************************
cmdb.cmd.clear:
        mov   @cmdb.cmd.clear.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.clear.vector:
        data  vec.25


***************************************************************
* Stub for "cmdb.cmdb.getlength"
* bank3 vec.26
********|*****|*********************|**************************
cmdb.cmd.getlength:
        mov   @cmdb.cmd.getlength.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.getlength.vector:
        data  vec.26


***************************************************************
* Stub for "cmdb.cmdb.preset"
* bank3 vec.27
********|*****|*********************|**************************
cmdb.cmd.preset:
        mov   @cmdb.cmd.preset.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.preset.vector:
        data  vec.27


***************************************************************
* Stub for "cmdb.cmdb.set"
* bank3 vec.28
********|*****|*********************|**************************
cmdb.cmd.set:
        mov   @cmdb.cmd.set.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.set.vector:
        data  vec.28


**************************************************************
* Stub for "tibasic.sid.toggle"
* bank3 vec.32
********|*****|*********************|**************************
tibasic.sid.toggle:
        mov   @tibasic.sid.toggle.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
tibasic.sid.toggle.vector:
        data  vec.31


**************************************************************
* Stub for "fm.fastmode"
* bank3 vec.32
********|*****|*********************|**************************
fm.fastmode:
        mov   @fm.fastmode.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
fm.fastmode.vector:
        data  vec.32




***************************************************************
* Trampoline bank 3 with return
********|*****|*********************|**************************
_trampoline.bank3.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in specified bank
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
              data bank4.rom        ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.ruler.init"
* bank4 vec.2
********|*****|*********************|**************************
fb.ruler.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Setup ruler in memory
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.2            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.colorlines"
* bank4 vec.3
********|*****|*********************|**************************
fb.colorlines:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.3            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.vdpdump"
* bank4 vec.4
********|*****|*********************|**************************
fb.vdpdump:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.4            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



**************************************************************
* Stub for "edb.clear.sams"
* bank5 vec.1
********|*****|*********************|**************************
edb.clear.sams:
        mov   @edb.clear.sams.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.clear.sams.vector:
        data  vec.1


**************************************************************
* Stub for "edb.hipage.alloc"
* bank5 vec.2
********|*****|*********************|**************************
edb.hipage.alloc:
        mov   @edb.hipage.alloc.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.hipage.alloc.vector:
        data  vec.2


**************************************************************
* Stub for "edb.block.mark"
* bank5 vec.3
********|*****|*********************|**************************
edb.block.mark:
        mov   @edb.block.mark.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.vector:
        data  vec.3


**************************************************************
* Stub for "edb.block.mark.m1"
* bank5 vec.4
********|*****|*********************|**************************
edb.block.mark.m1:
        mov   @edb.block.mark.m1.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.m1.vector:
        data  vec.4


**************************************************************
* Stub for "edb.block.mark.m2"
* bank5 vec.5
********|*****|*********************|**************************
edb.block.mark.m2:
        mov   @edb.block.mark.m2.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.m2.vector:
        data  vec.5


**************************************************************
* Stub for "edb.block.clip"
* bank5 vec.6
********|*****|*********************|**************************
edb.block.clip:
        mov   @edb.block.clip.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.clip.vector:
        data  vec.6


**************************************************************
* Stub for "edb.block.reset"
* bank5 vec.7
********|*****|*********************|**************************
edb.block.reset:
        mov   @edb.block.reset.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.reset.vector:
        data  vec.7


**************************************************************
* Stub for "edb.block.delete"
* bank5 vec.8
********|*****|*********************|**************************
edb.block.delete:
        mov   @edb.block.delete.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.delete.vector:
        data  vec.8


**************************************************************
* Stub for "edb.block.copy"
* bank5 vec.9
********|*****|*********************|**************************
edb.block.copy:
        mov   @edb.block.copy.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.copy.vector:
        data  vec.9


**************************************************************
* Stub for "edb.line.del"
* bank5 vec.10
********|*****|*********************|**************************
edb.line.del:
        mov   @edb.line.del.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.line.del.vector:
        data  vec.10



***************************************************************
* Trampoline bank 5 with return
********|*****|*********************|**************************
_trampoline.bank5.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in specified bank
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
* Stub for "vdp.patterns.dump"
* bank6 vec.1
********|*****|*********************|**************************
vdp.patterns.dump:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank6.rom        ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* Stub for "tibasic"
* bank7 vec.10
********|*****|*********************|**************************
tibasic1:
        li    tmp0,1
        mov   tmp0,@tibasic.session
        jmp   tibasic
tibasic2:
        li    tmp0,2
        mov   tmp0,@tibasic.session
        jmp   tibasic
tibasic3:
        li    tmp0,3
        mov   tmp0,@tibasic.session
        jmp   tibasic
tibasic4:
        li    tmp0,4
        mov   tmp0,@tibasic.session
        jmp   tibasic
tibasic5:
        li    tmp0,5
        mov   tmp0,@tibasic.session
tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Update TI basic session info
        ;------------------------------------------------------
        mov   @tibasic.session,tmp0 ; Get current TI basic session
        dec   tmp0                  ; Base 0
        sla   tmp0,2                ; Word align
        mov   @w$0001,@tibasic1.status(tmp0)
                                    ; Set resume flag for next run
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
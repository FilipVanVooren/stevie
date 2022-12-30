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
* Stub for dialog "Shortcuts"
* bank3 vec.14
********|*****|*********************|**************************
dialog.shortcuts:
        mov   @dialog.shortcuts.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.shortcuts.vector:
        data  vec.14


***************************************************************
* Stub for dialog "Configure editor"
* bank3 vec.15
********|*****|*********************|**************************
dialog.editor:
        mov   @dialog.editor.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.editor.vector:
        data  vec.15


***************************************************************
* Stub for dialog "Go to line"
* bank3 vec.16
********|*****|*********************|**************************
dialog.goto:
        mov   @dialog.goto.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.goto.vector:
        data  vec.16


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
        jeq   !                     ; Block mode inactive, show dialog
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



***************************************************************
* Stub for "tibasic.hearts.tat"
* bank3 vec.29
********|*****|*********************|**************************
tibasic.hearts.tat:
        mov   @tibasic.hearts.tat.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
tibasic.hearts.tat.vector:
        data  vec.29



**************************************************************
* Stub for "tibasic.am.toggle"
* bank3 vec.31
********|*****|*********************|**************************
tibasic.am.toggle:
        mov   @tibasic.am.toggle.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
tibasic.am.toggle.vector:
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


***************************************************************
* Stub for "fb.hscroll"
* bank4 vec.6
********|*****|*********************|**************************
fb.hscroll:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.6            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.restore"
* bank4 vec.7
********|*****|*********************|**************************
fb.restore:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.7            ; | i  p1 = Vector with target address
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
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.8            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.get.nonblank"
* bank4 vec.9
********|*****|*********************|**************************
fb.get.nonblank:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Colorize frame buffer content
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.9            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.tab.prev"
* bank4 vec.10
********|*****|*********************|**************************
fb.tab.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Put cursor on next tab position
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* Stub for "fb.tab.next"
* bank4 vec.11
********|*****|*********************|**************************
fb.tab.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Put cursor on next tab position
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank4.rom        ; | i  p0 = bank address
              data vec.11           ; | i  p1 = Vector with target address
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
        mov   @const.1,@tib.session
        jmp   tibasic
tibasic2:
        mov   @const.2,@tib.session
        jmp   tibasic
tibasic3:
        mov   @const.3,@tib.session
        jmp   tibasic
tibasic4:
        mov   @const.4,@tib.session
        jmp   tibasic
tibasic5:
        mov   @const.5,@tib.session
tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Exit early if no TI Basic session
        ;------------------------------------------------------
        mov   @tib.session,tmp0     ; Get session ID
        jeq   tibasic.exit          ; Exit early if no session
        ;------------------------------------------------------
        ; Run TI Basic session
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return

        mov   @tib.automode,tmp0    ; AutoMode flag set?
        jeq   tibasic.exit          ; No, skip uncrunching

        bl    @tibasic.uncrunch     ; Uncrunch TI Basic program
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* Stub for "tibasic.uncrunch"
* bank7 vec.11
********|*****|*********************|**************************
tibasic.uncrunch:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Uncrunch TI basic program
        ;------------------------------------------------------
        mov   @tib.session,@parm1   ; Get current session
        jeq   tibasic.uncrunch.exit ; Exit early if no session

        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank7.rom        ; | i  p0 = bank address
              data vec.11           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.uncrunch.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* Stub for "fg99.run"
********|*****|*********************|**************************
fg99.run.xbgem:
        li    tmp0,fg99.cart.xbgem  ; Load Extended Basic G.E.M
        mov   tmp0,@tv.fg99.img.ptr ; Set pointer        
        jmp   fg99.run.stub

fg99.run.rxb:
        li    tmp0,fg99.cart.rxb    ; Load Rich Extended Basic
        mov   tmp0,@tv.fg99.img.ptr ; Set pointer        
        jmp   fg99.run.stub

fg99.run.fcmd:
        li    tmp0,fg99.cart.fcmd   ; Load Force Command
        mov   tmp0,@tv.fg99.img.ptr ; Set pointer
        jmp   fg99.run.stub

fg99.run.fbforth:
        li    tmp0,fg99.cart.fbforth ; Load fbForth
        mov   tmp0,@tv.fg99.img.ptr  ; Set pointer
        jmp   fg99.run.stub

fg99.run.stub:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Run FinalGROM cartridge image
        ;------------------------------------------------------
        bl    @fg99.run             ; Run FinalGROM cartridge
                                    ; \ i @tv.fg99.img.ptr = Pointer to image
                                    ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fg99.run.stub.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

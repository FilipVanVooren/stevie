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
* Stub for "fm.directory"
* bank2 vec.6
********|*****|*********************|**************************
fm.directory:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.6            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "fm.browse.fname.prev"
* bank2 vec.10
********|*****|*********************|**************************
fm.browse.fname.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

***************************************************************
* Stub for "fm.browse.fname.next"
* bank2 vec.11
********|*****|*********************|**************************
fm.browse.fname.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 2
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.11           ; | i  p1 = Vector with target address
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
* Stub for dialog "Dir"
* bank3 vec.15
********|*****|*********************|**************************
dialog.cat:
        mov   @dialog.cat.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.cat.vector:
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
* Stub for dialog "Configure font"
* bank3 vec.17
********|*****|*********************|**************************
dialog.font:
        mov   @dialog.font.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.font.vector:
        data  vec.17


***************************************************************
* Stub for dialog "Configure Master Catalog"
* bank3 vec.18
********|*****|*********************|**************************
dialog.cfg.mc:
        mov   @dialog.cfg.mc.vector,@trmpvector
        jmp   _trampoline.bank3     ; Show dialog
dialog.cfg.mc.vector:
        data  vec.18


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
* Stub for "dialog.hearts.tat"
* bank3 vec.29
********|*****|*********************|**************************
dialog.hearts.tat:
        mov   @dialog.hearts.tat.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
dialog.hearts.tat.vector:
        data  vec.29



***************************************************************
* Stub for "tibasic.am.toggle"
* bank3 vec.31
********|*****|*********************|**************************
tibasic.am.toggle:
        mov   @tibasic.am.toggle.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
tibasic.am.toggle.vector:
        data  vec.31


***************************************************************
* Stub for "fm.fastmode"
* bank3 vec.32
********|*****|*********************|**************************
fm.fastmode:
        mov   @fm.fastmode.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
fm.fastmode.vector:
        data  vec.32


***************************************************************
* Stub for "cmdb.cfg.fname"
* bank3 vec.33
********|*****|*********************|**************************
cmdb.cfg.fname:
        mov   @cmdb.cfg.fname.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cfg.fname.vector:
        data  vec.33

***************************************************************
* Stub for "fm.lineterm"
* bank3 vec.34
********|*****|*********************|**************************
fm.lineterm:
        mov   @fm.lineterm.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
fm.lineterm.vector:
        data  vec.34


***************************************************************
* Stub for "dialog"
* bank3 vec.42
********|*****|*********************|**************************
dialog:
        mov   @dialog.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
dialog.vector:
        data  vec.42


***************************************************************
* Stub for "error.display"
* bank3 vec.48
********|*****|*********************|**************************
error.display:
        mov   @error.display.vector,@trmpvector
        jmp   _trampoline.bank3.ret ; Longjump
error.display.vector:
        data  vec.48



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
        mov   @fb.ruler.init.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.ruler.init.vector:
        data  vec.2


***************************************************************
* Stub for "fb.colorlines"
* bank4 vec.3
********|*****|*********************|**************************
fb.colorlines:
        mov   @fb.colorlines.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.colorlines.vector:
        data  vec.3


***************************************************************
* Stub for "fb.vdpdump"
* bank4 vec.4
********|*****|*********************|**************************
fb.vdpdump:
        mov   @fb.vdpdump.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.vdpdump.vector:
        data  vec.4


***************************************************************
* Stub for "fb.hscroll"
* bank4 vec.6
********|*****|*********************|**************************
fb.hscroll:
        mov   @fb.hscroll.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.hscroll.vector:
        data  vec.6


***************************************************************
* Stub for "fb.restore"
* bank4 vec.7
********|*****|*********************|**************************
fb.restore:
        mov   @fb.restore.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.restore.vector:
        data  vec.7


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
* Stub for "fb.get.nonblank"
* bank4 vec.9
********|*****|*********************|**************************
fb.get.nonblank:
        mov   @fb.get.nonblank.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.get.nonblank.vector:
        data  vec.9


***************************************************************
* Stub for "fb.tab.prev"
* bank4 vec.10
********|*****|*********************|**************************
fb.tab.prev:
        mov   @fb.tab.prev.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.tab.prev.vector:
        data  vec.10


***************************************************************
* Stub for "fb.tab.next"
* bank4 vec.11
********|*****|*********************|**************************
fb.tab.next:
        mov   @fb.tab.next.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.tab.next.vector:
        data  vec.11


***************************************************************
* Stub for "fb.cursor.up"
* bank4 vec.12
********|*****|*********************|**************************
fb.cursor.up:
        mov   @fb.cursor.up.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.up.vector:
        data  vec.12


***************************************************************
* Stub for "fb.cursor.down"
* bank4 vec.13
********|*****|*********************|**************************
fb.cursor.down:
        mov   @fb.cursor.down.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.down.vector:
        data  vec.13


***************************************************************
* Stub for "fb.cursor.home"
* bank4 vec.14
********|*****|*********************|**************************
fb.cursor.home:
        mov   @fb.cursor.home.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.home.vector:
        data  vec.14


***************************************************************
* Stub for "fb.insert.line"
* bank4 vec.15
********|*****|*********************|**************************
fb.insert.line:
        mov   @fb.insert.line.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.insert.line.vector:
        data  vec.15


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
* Stub for "fb.cursor.topscr"
* bank4 vec.17
********|*****|*********************|**************************
fb.cursor.topscr:
        mov   @fb.cursor.topscr.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.topscr.vector:
        data  vec.17


***************************************************************
* Stub for "fb.cursor.bot"
* bank4 vec.18
********|*****|*********************|**************************
fb.cursor.bot:
        mov   @fb.cursor.bot.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.bot.vector:
        data  vec.18


***************************************************************
* Stub for "fb.cursor.botscr"
* bank4 vec.19
********|*****|*********************|**************************
fb.cursor.botscr:
        mov   @fb.cursor.botscr.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.cursor.botscr.vector:
        data  vec.19


***************************************************************
* Stub for "fb.insert.char"
* bank4 vec.20
********|*****|*********************|**************************
fb.insert.char:
        mov   @fb.insert.char.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.insert.char.vector:
        data  vec.20


***************************************************************
* Stub for "fb.replace.char"
* bank4 vec.21
********|*****|*********************|**************************
fb.replace.char:
        mov   @fb.replace.char.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
fb.replace.char.vector:
        data  vec.21


***************************************************************
* Stub for "pane.topline"
* bank4 vec.33
********|*****|*********************|**************************
pane.topline:
        mov   @pane.topline.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.topline.vector:
        data  vec.33


***************************************************************
* Stub for "pane.botline"
* bank4 vec.34
********|*****|*********************|**************************
pane.botline:
        mov   @pane.botline.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.botline.vector:
        data  vec.34


***************************************************************
* Stub for "pane.errline.show"
* bank4 vec.35
********|*****|*********************|**************************
pane.errline.show:
        mov   @pane.errline.show.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.errline.show.vector:
        data  vec.35


***************************************************************
* Stub for "pane.errline.hide"
* bank4 vec.36
********|*****|*********************|**************************
pane.errline.hide:
        mov   @pane.errline.hide.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.errline.hide.vector:
        data  vec.36


***************************************************************
* Stub for "pane.errline.drawcolor"
* bank4 vec.37
********|*****|*********************|**************************
pane.errline.drawcolor:
        mov   @pane.errline.drawcolor.vector,@trmpvector
        jmp   _trampoline.bank4.ret ; Longjump
pane.errline.drawcolor.vector:
        data  vec.37


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
* Trampoline bank 4 with return
********|*****|*********************|**************************
_trampoline.bank4.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in specified bank
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
* Stub for "edb.clear.sams"
* bank5 vec.1
********|*****|*********************|**************************
edb.clear.sams:
        mov   @edb.clear.sams.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.clear.sams.vector:
        data  vec.1


***************************************************************
* Stub for "edb.block.mark"
* bank5 vec.3
********|*****|*********************|**************************
edb.block.mark:
        mov   @edb.block.mark.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.vector:
        data  vec.3


***************************************************************
* Stub for "edb.block.mark.m1"
* bank5 vec.4
********|*****|*********************|**************************
edb.block.mark.m1:
        mov   @edb.block.mark.m1.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.m1.vector:
        data  vec.4


***************************************************************
* Stub for "edb.block.mark.m2"
* bank5 vec.5
********|*****|*********************|**************************
edb.block.mark.m2:
        mov   @edb.block.mark.m2.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.mark.m2.vector:
        data  vec.5


***************************************************************
* Stub for "edb.block.clip"
* bank5 vec.6
********|*****|*********************|**************************
edb.block.clip:
        mov   @edb.block.clip.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.clip.vector:
        data  vec.6


***************************************************************
* Stub for "edb.block.reset"
* bank5 vec.7
********|*****|*********************|**************************
edb.block.reset:
        mov   @edb.block.reset.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.reset.vector:
        data  vec.7


***************************************************************
* Stub for "edb.block.delete"
* bank5 vec.8
********|*****|*********************|**************************
edb.block.delete:
        mov   @edb.block.delete.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.delete.vector:
        data  vec.8


***************************************************************
* Stub for "edb.block.copy"
* bank5 vec.9
********|*****|*********************|**************************
edb.block.copy:
        mov   @edb.block.copy.vector,@trmpvector
        jmp   _trampoline.bank5.ret ; Longjump
edb.block.copy.vector:
        data  vec.9


***************************************************************
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
* Stub for "vdp.dump.patterns"
* bank6 vec.1
********|*****|*********************|**************************
vdp.dump.patterns:
        mov   @vdp.dump.patterns.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.dump.patterns.vector:
        data  vec.1


***************************************************************
* Stub for "vdp.dump.font"
* bank6 vec.2
********|*****|*********************|**************************
vdp.dump.font:
        mov   @vdp.dump.font.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
vdp.dump.font.vector:
        data  vec.2


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
* Stub for "tv.set.font"
* bank6 vec.33
********|*****|*********************|**************************
tv.set.font:
        mov   @tv.set.font.vector,@trmpvector
        jmp   _trampoline.bank6.ret ; Longjump
tv.set.font.vector:
        data  vec.33


***************************************************************
* Trampoline bank 6 with return
********|*****|*********************|**************************
_trampoline.bank6.ret:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in specified bank
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

        mov   @tib.autounpk,tmp0    ; AutoUnpack flag set?
        jeq   tibasic.exit          ; No, skip uncrunching

        bl    @tibasic.uncrunch     ; Uncrunch TI Basic program
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.exit:
        seto  @fb.status.dirty      ; Trigger status lines update
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
* Stub for "tv.reset"
* bank7 vec.23
********|*****|*********************|**************************
tv.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call routine in specified bank
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

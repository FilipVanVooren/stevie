* FILE......: rom.stubs.bank1.asm
* Purpose...: Bank 1 stubs for functions in other banks


***************************************************************
* Stub for "vdp.patterns.dump"
* bank5 vec.1
********|*****|*********************|**************************
vdp.patterns.dump:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump VDP patterns
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank5.rom        ; | i  p0 = bank address
              data vec.1            ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


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
* Stub for dialog "Help"
* bank3 vec.1
********|*****|*********************|**************************
edkey.action.about:
        mov   @edkey.action.about.vector,@parm1
        b     @_trampoline.bank3    ; Show dialog        
edkey.action.about.vector:        
        data  vec.1


***************************************************************
* Stub for dialog "Load DV80 file"
* bank3 vec.2
********|*****|*********************|**************************
dialog.load:
        mov   @dialog.load.vector,@parm1
        b     @_trampoline.bank3    ; Show dialog
dialog.load.vector:
        data  vec.2


***************************************************************
* Stub for dialog "Save DV80 file"
* bank3 vec.3
********|*****|*********************|**************************
dialog.save:
        mov   @dialog.save.vector,@parm1
        b     @_trampoline.bank3    ; Show dialog
dialog.save.vector:        
        data  vec.3


***************************************************************
* Stub for dialog "Insert DV80 file"
* bank3 vec.4
********|*****|*********************|**************************
dialog.insert:
        mov   @dialog.insert.vector,@parm1
        jmp   _trampoline.bank3     ; Show dialog
dialog.insert.vector:        
        data  vec.4


***************************************************************
* Stub for dialog "File"
* bank3 vec.5
********|*****|*********************|**************************
dialog.file:
        mov   @dialog.file.vector,@parm1
        jmp   _trampoline.bank3     ; Show dialog
dialog.file.vector:        
        data  vec.5


***************************************************************
* Stub for dialog "Unsaved Changes"
* bank3 vec.6
********|*****|*********************|**************************
dialog.unsaved:
        clr   @cmdb.panmarkers      ; No key markers
        mov   @dialog.unsaved.vector,@parm1
        jmp   _trampoline.bank3     ; Show dialog
dialog.unsaved.vector:        
        data  vec.6


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
!       mov   @dialog.menu.vector,@parm1        
        jmp   _trampoline.bank3     ; Show dialog
dialog.menu.vector:        
        data  vec.30


***************************************************************
* Stub for "tibasic"
* bank3 vec.10
********|*****|*********************|**************************
tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Call function in bank 3
        ;------------------------------------------------------             
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank3.rom        ; | i  p0 = bank address
              data vec.10           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* Stub for "pane.show_hint"
* bank3 vec.18
********|*****|*********************|**************************
pane.show_hint:
        mov   @pane.show_hint,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
pane.show_hint.vector:
        data  vec.18


***************************************************************
* Stub for "pane.cmdb.show"
* bank3 vec.20
********|*****|*********************|**************************
pane.cmdb.show:
        mov   @pane.cmdb.show.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.show.vector:
        data  vec.20


***************************************************************
* Stub for "pane.cmdb.hide"
* bank3 vec.21
********|*****|*********************|**************************
pane.cmdb.hide:
        mov   @pane.cmdb.hide.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.hide.vector:
        data  vec.21


***************************************************************
* Stub for "pane.cmdb.draw"
* bank3 vec.22
********|*****|*********************|**************************
pane.cmdb.draw:
        mov   @pane.cmdb.draw.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
pane.cmdb.draw.vector:
        data  vec.22


***************************************************************
* Stub for "cmdb.refresh"
* bank3 vec.24
********|*****|*********************|**************************
cmdb.refresh:
        mov   @cmdb.refresh.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.refresh.vector:
        data  vec.24


***************************************************************
* Stub for "cmdb.cmd.clear"
* bank3 vec.25
********|*****|*********************|**************************
cmdb.cmd.clear:
        mov   @cmdb.cmd.clear.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.clear.vector:
        data  vec.25


***************************************************************
* Stub for "cmdb.cmdb.getlength"
* bank3 vec.26
********|*****|*********************|**************************
cmdb.cmd.getlength:
        mov   @cmdb.cmd.getlength.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.getlength.vector:
        data  vec.26


***************************************************************
* Stub for "cmdb.cmdb.addhist"
* bank3 vec.27
********|*****|*********************|**************************
cmdb.cmd.addhist:
        mov   @cmdb.cmd.addhist.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
cmdb.cmd.addhist.vector:
        data  vec.27





**************************************************************
* Stub for "fm.fastmode"
* bank3 vec.32
********|*****|*********************|**************************
fm.fastmode:
        mov   @fm.fastmode.vector,@parm1
        jmp   _trampoline.bank3.ret ; Longjump
fm.fastmode.vector:
        data  vec.32


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
                                    ; |         (deref @parm1)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane


***************************************************************
* Trampoline 2 (bank 3 with return)
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
                                    ; |         (deref @parm1)
              data bankid           ; / i  p2 = Source ROM bank for return
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

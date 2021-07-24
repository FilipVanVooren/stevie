* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.

*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        ;-------------------------------------------------------
        ; Show dialog "unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   !
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Quit Stevie
        ;-------------------------------------------------------
!       b     @tv.quit



*---------------------------------------------------------------
* Toggle ruler on/off
********|*****|*********************|**************************
edkey.action.toggle.ruler:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @wyx,*stack           ; Push cursor YX
        ;-------------------------------------------------------
        ; Toggle ruler visibility
        ;-------------------------------------------------------
        seto  @fb.dirty             ; Screen refresh necessary        
        inv   @tv.ruler.visible     ; Toggle ruler visibility
        jeq   edkey.action.toggle.ruler.fb
        bl    @fb.ruler.init        ; Setup ruler in ram
        ;-------------------------------------------------------
        ; Update framebuffer pane
        ;-------------------------------------------------------
edkey.action.toggle.ruler.fb:
        bl    @pane.cmdb.hide       ; Actions are the same as when hiding CMDB
        mov   *stack+,@wyx          ; Pop cursor YX
        mov   *stack+,tmp0          ; Pop tmp0
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.toggle.ruler.exit:        
        b     @hook.keyscan.bounce  ; Back to editor main

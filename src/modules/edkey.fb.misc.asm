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
        ; Reset and lock F18a
        ;-------------------------------------------------------
!       bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit


*---------------------------------------------------------------
* Toggle ruler on/off
********|*****|*********************|**************************
edkey.action.toggle.ruler:
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
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.toggle.ruler.exit:        
        b     @hook.keyscan.bounce  ; Back to editor main

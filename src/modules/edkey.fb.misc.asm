* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.


*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit


*---------------------------------------------------------------
* No action at all
*---------------------------------------------------------------
edkey.action.noop:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Show/Hide command buffer pane
********|*****|*********************|**************************
edkey.action.cmdb.toggle:
        mov   @cmdb.visible,tmp0
        jne   edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; Show pane
        ;-------------------------------------------------------
edkey.action.cmdb.show:        
        bl    @pane.cmdb.show       ; Show command buffer pane
        jmp   edkey.action.cmdb.toggle.exit
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
edkey.action.cmdb.hide:
        bl    @pane.cmdb.hide       ; Hide command buffer pane
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.toggle.exit:
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Framebuffer down 1 row
*---------------------------------------------------------------
edkey.action.fbdown:
        inc   @fb.scrrows
        seto  @fb.dirty

        b     *r11  


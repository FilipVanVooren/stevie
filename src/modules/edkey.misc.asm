* FILE......: edkey.misc.asm
* Purpose...: Actions for miscelanneous keys


*---------------------------------------------------------------
* Quit TiVi
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit
        


*---------------------------------------------------------------
* Show/Hide command buffer pane
********|*****|*********************|**************************
edkey.action.cmdb.toggle:
        inv   @cmdb.visible
*       jeq   edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; Show pane
        ;-------------------------------------------------------
edkey.action.cmdb.show:        
        li    tmp0,5
        mov   tmp0,@parm1           ; Set pane size

        bl    @cmdb.show            ; \ Show command buffer pane
                                    ; | i  parm1 = Size in rows
                                    ; /
        jmp   edkey.action.cmdb.toggle.exit
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
edkey.action.cmdb.hide:
        bl    @cmdb.hide             ; Hide command buffer pane

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.toggle.exit:
        b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Framebuffer down 1 row
*---------------------------------------------------------------
edkey.action.fbdown:
        inc   @fb.scrrows
        seto  @fb.dirty

        bl    *r11

* FILE......: edkey.cmdb.misc.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

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
        clr   @cmdb.column          ; Column = 0      
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
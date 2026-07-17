* FILE......: edk.cmdb.misc.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

*---------------------------------------------------------------
* Show/Hide command buffer pane
********|*****|*********************|**************************
edk.act.cmdb.toggle:
        mov   @cmdb.visible,tmp0
        jne   edk.act.cmdb.hide
        ;-------------------------------------------------------
        ; Show pane
        ;-------------------------------------------------------
edk.act.cmdb.show:  
        clr   @cmdb.column          ; Column = 0      
        bl    @pane.cmdb.show       ; Show command buffer pane
        jmp   edk.act.cmdb.toggle.exit
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
edk.act.cmdb.hide:
        bl    @pane.cmdb.hide       ; Hide command buffer pane
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.toggle.exit:
        b     @edkey.keyscan.hook.debounce; Back to editor main
        
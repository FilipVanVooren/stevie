* FILE......: edkey.cmdb.labels.refresh.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

*---------------------------------------------------------------
* Refresh index with search results
********|*****|*********************|**************************
edkey.action.cmdb.find.refresh:
        ;-------------------------------------------------------
        ; Search string in editor buffer
        ;-------------------------------------------------------
        bl    @edb.find.scan        ; Refresh index with search results
        bl    @pane.cmdb.show
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.find.refresh.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

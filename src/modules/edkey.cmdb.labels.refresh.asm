* FILE......: edkey.cmdb.labels.refresh.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

*---------------------------------------------------------------
* Refresh labels index in source code
********|*****|*********************|**************************
edkey.action.cmdb.labels.refresh:
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
        bl    @edb.labels.scan      ; Refresh index of source code labels
        bl    @pane.cmdb.hide       ; Hide command buffer pane
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.labels.refresh.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

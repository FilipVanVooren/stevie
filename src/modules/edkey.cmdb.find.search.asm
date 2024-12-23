* FILE......: edkey.cmdb.find.search.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

*---------------------------------------------------------------
* Refresh index with search results
********|*****|*********************|**************************
edkey.action.cmdb.find.search:
        bl    @edb.find.search      ; Perform search operation
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.find.search.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

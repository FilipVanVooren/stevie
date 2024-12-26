* FILE......: edkey.cmdb.find.search.asm
* Purpose...: Actions for miscelanneous keys in command buffer pane.

*---------------------------------------------------------------
* Refresh index with search results
********|*****|*********************|**************************
edkey.action.cmdb.find.search:
        bl    @edb.find.search      ; Perform search operation
        abs   @edb.srch.matches     ; Any search matches found?
        jgt   edkey.action.cmdb.find.search.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; No search matches, jump to 1st line in file
        ;-------------------------------------------------------
        clr   @parm1                ; 1st line in file
        b     @edkey.action.goto    ; Goto specified line        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.find.search.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

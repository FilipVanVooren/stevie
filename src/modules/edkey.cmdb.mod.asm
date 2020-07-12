* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.



*---------------------------------------------------------------
* Clear current command
*---------------------------------------------------------------
edkey.action.cmdb.clear:
        ;-------------------------------------------------------
        ; Clear current command
        ;-------------------------------------------------------
        bl    @cmdb.cmd.clear       ; Clear current command
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.clear.exit:
        b     @edkey.action.cmdb.home
                                    ; Reposition cursor
        




*---------------------------------------------------------------
* Process character
********|*****|*********************|**************************
edkey.action.cmdb.char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        li    tmp0,cmdb.cmd         ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  tmp1,*tmp0            ; Add character
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor

        bl    @cmdb.cmd.getlength   ; Get length of current command
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edkey.action.cmdb.enter:
        ;-------------------------------------------------------
        ; Parse command
        ;-------------------------------------------------------
        ; TO BE IMPLEMENTED

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.enter.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

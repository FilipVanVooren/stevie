* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.


*---------------------------------------------------------------
* Process character
********|*****|*********************|**************************
edkey.cmdb.action.char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        li    tmp0,cmdb.command     ; Get beginning of command
        a     @cmdb.column,tmp0     ; Add current column to command
        movb  tmp1,*tmp0            ; Add character
        inc   @cmdb.column          ; Next column
        inc   @cmdb.cursor          ; Next column cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.cmdb.action.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

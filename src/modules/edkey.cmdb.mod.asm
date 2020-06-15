* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.


*---------------------------------------------------------------
* Insert character
*
* @parm1 = high byte has character to insert
********|*****|*********************|**************************
edkey.cmdb.action.ins_char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Loop from end of line until current character
        ;-------------------------------------------------------
edkey.cmdb.action.ins_char_loop:
        movb  *tmp0,*tmp1           ; Move char to the right
        dec   tmp0
        dec   tmp1
        dec   tmp2
        jne   edkey.cmdb.action.ins_char_loop
        ;-------------------------------------------------------
        ; Set specified character on current position
        ;-------------------------------------------------------
        movb  @parm1,*tmp1
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.cmdb.action.ins_char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Process character
********|*****|*********************|**************************
edkey.cmdb.action.char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        mov   @cmdb.top.ptr,tmp0
        a     @cmdb.column,tmp0
        movb  tmp1,*tmp0

        inc   @cmdb.column                
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.cmdb.action.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

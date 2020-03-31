* FILE......: edkey.cmdb.mod.asm
* Purpose...: Actions for modifier keys in command buffer pane.


*---------------------------------------------------------------
* Insert character
*
* @parm1 = high byte has character to insert
*---------------------------------------------------------------
edkey.cmdb.action.ins_char.ws:
        li    tmp0,>2000            ; White space
        mov   tmp0,@parm1
edkey.cmdb.action.ins_char:
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Prepare for insert operation
        ;-------------------------------------------------------
edkey.cmdb.action.skipsanity:
        mov   tmp2,tmp3             ; tmp3=line length
        s     @fb.column,tmp3
        a     tmp3,tmp0             ; tmp0=Pointer to last char in line
        mov   tmp0,tmp1
        inc   tmp1                  ; tmp1=tmp0+1
        s     @fb.column,tmp2       ; tmp2=amount of characters to move
        inc   tmp2
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
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        inc   @fb.row.length        ; @fb.row.length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.cmdb.action.ins_char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Process character
*---------------------------------------------------------------
edkey.cmdb.action.char:
        seto  @cmdb.dirty           ; Editor buffer dirty (text changed!)
        movb  tmp1,@parm1           ; Store character for insert
        ;-------------------------------------------------------
        ; Only insert mode supported
        ;-------------------------------------------------------
edkey.cmdb.action.char.insert:
        b     @edkey.action.ins_char
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.cmdb.action.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

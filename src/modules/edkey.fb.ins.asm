* FILE......: edkey.fb.ins.asm
* Purpose...: Insert related actions in frame buffer pane.

*---------------------------------------------------------------
* Insert character
*
* @parm1 = high byte has character to insert
*---------------------------------------------------------------
edkey.action.ins_char.ws:
        li    tmp0,>2000            ; White space
        mov   tmp0,@parm1
edkey.action.ins_char:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Assert 1 - Empty line
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Assert 2 - EOL
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Wrap to new line if at character 80
        ;-------------------------------------------------------
        mov   @fb.column,tmp1    
        ci    tmp1,colrow - 1       ; Overwrite if last column in row
        jlt   !
        
        bl    @fb.cursor.down       ; Move cursor down 1 line
        bl    @fb.insert.line       ; Insert new line
        b     @edkey.action.ins_line
                                    ; Now insert a line
        jmp   edkey.action.ins_char.prep
        ;-------------------------------------------------------
        ; Assert 4 - 80 characters maximum
        ;-------------------------------------------------------
!       mov   @fb.row.length,tmp1
        ci    tmp1,colrow
        jlt   edkey.action.ins_char.prep
        jmp   edkey.action.ins_char.exit        
        ;-------------------------------------------------------
        ; Calculate number of characters to move
        ;-------------------------------------------------------
edkey.action.ins_char.prep:
        mov   tmp2,tmp3             ; tmp3=line length        
        s     @fb.column,tmp3
        dec   tmp3                  ; Remove base 1 offset 
        a     tmp3,tmp0             ; tmp0=Pointer to last char in line
        mov   tmp0,tmp1
        inc   tmp1                  ; tmp1=tmp0+1
        s     @fb.column,tmp2       ; tmp2=amount of characters to move
        ;-------------------------------------------------------
        ; Loop from end of line until current character
        ;-------------------------------------------------------
edkey.action.ins_char.loop:
        movb  *tmp0,*tmp1           ; Move char to the right
        dec   tmp0
        dec   tmp1
        dec   tmp2
        jne   edkey.action.ins_char.loop
        ;-------------------------------------------------------
        ; Insert specified character at current position
        ;-------------------------------------------------------
        movb  @parm1,*tmp1          ; MSB has character to insert
        ;-------------------------------------------------------
        ; Save variables and exit
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        inc   @fb.column
        inc   @wyx
        inc   @fb.row.length        ; @fb.row.length
        jmp   edkey.action.ins_char.exit
        ;-------------------------------------------------------
        ; Add character in append mode
        ;-------------------------------------------------------
edkey.action.ins_char.append:
        b     @edkey.action.char.overwrite
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main






*---------------------------------------------------------------
* Insert new line
*---------------------------------------------------------------
edkey.action.ins_line:
        bl    @fb.insert.line       ; Insert new line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_line.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
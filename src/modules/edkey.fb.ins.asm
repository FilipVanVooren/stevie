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
        ; Check 1 - Empty line
        ;-------------------------------------------------------
edkey.actions.ins.char.empty_line:        
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Check 2 - line-wrap if at character 80
        ;-------------------------------------------------------
        mov   @fb.column,tmp1    
        ci    tmp1,colrow-1         ; At 80th character?
        jlt   !
        mov   @fb.row.length,tmp1
        ci    tmp1,colrow
        jne   ! 
        ;-------------------------------------------------------
        ; Wrap to new line
        ;-------------------------------------------------------
        dect  Stack
        mov   @parm1,*stack         ; Save character to add
        bl    @fb.cursor.down       ; Move cursor down 1 line
        bl    @fb.insert.line       ; Insert empty line
        mov   *stack+,@parm1        ; Restore character to add
        clr   tmp2                  ; Clear line length
        jmp   edkey.action.ins_char.append
        ;-------------------------------------------------------
        ; Check 3 - EOL
        ;-------------------------------------------------------
!       c     @fb.column,@fb.row.length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Check 4 - Insert only until line length reaches 80th column
        ;-------------------------------------------------------
        mov   @fb.row.length,tmp1
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
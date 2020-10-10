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
        ; Sanity check 1 - Empty line
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Sanity check 2 - EOL
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   edkey.action.ins_char.append
                                    ; Add character in append mode
        ;-------------------------------------------------------
        ; Prepare for insert operation
        ;-------------------------------------------------------
edkey.action.skipsanity:
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
edkey.action.ins_char.loop:
        movb  *tmp0,*tmp1           ; Move char to the right
        dec   tmp0
        dec   tmp1
        dec   tmp2
        jne   edkey.action.ins_char.loop
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
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.ins_line.insert
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Insert entry in index
        ;-------------------------------------------------------
edkey.action.ins_line.insert:        
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to insert
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        
        bl    @idx.entry.insert     ; Reorganize index
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg

        inc   @edb.lines            ; One line added to editor buffer
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_line.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

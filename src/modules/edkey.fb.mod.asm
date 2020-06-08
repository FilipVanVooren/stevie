* FILE......: edkey.fb.mod.asm
* Purpose...: Actions for modifier keys in frame buffer pane.


*---------------------------------------------------------------
* Delete character
*---------------------------------------------------------------
edkey.action.del_char:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Sanity check 1
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.del_char.exit
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Sanity check 2
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   edkey.action.del_char.exit
                                    ; Exit if at EOL
        ;-------------------------------------------------------
        ; Prepare for delete operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   tmp0,tmp1             ; Add 1 to pointer
        inc   tmp1               
        ;-------------------------------------------------------
        ; Loop until end of line
        ;-------------------------------------------------------
edkey.action.del_char_loop:
        movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
        dec   tmp2
        jne   edkey.action.del_char_loop
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        dec   @fb.row.length        ; @fb.row.length--
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete until end of line
*---------------------------------------------------------------
edkey.action.del_eol:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.del_eol.exit
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Prepare for erase operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.colsline,tmp2
        s     @fb.column,tmp2
        clr   tmp1
        ;-------------------------------------------------------
        ; Loop until last column in frame buffer
        ;-------------------------------------------------------
edkey.action.del_eol_loop:
        movb  tmp1,*tmp0+           ; Overwrite current char with >00
        dec   tmp2
        jne   edkey.action.del_eol_loop
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh

        mov   @fb.column,@fb.row.length
                                    ; Set new row length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_eol.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete current line
*---------------------------------------------------------------
edkey.action.del_line:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Special treatment if only 1 line in file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        jne   !
        clr   @fb.column            ; Column 0
        b     @edkey.action.del_eol ; Delete until end of line
        ;-------------------------------------------------------
        ; Delete entry in index
        ;-------------------------------------------------------
!       bl    @fb.calc_pointer      ; Calculate position in frame buffer
        clr   @fb.row.dirty         ; Discard current line        
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to remove
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        bl    @idx.entry.delete     ; Reorganize index
        dec   @edb.lines            ; One line less in editor buffer
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Special treatment if current line was last line
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Was last line?
        jle   edkey.action.del_line.exit
        b     @edkey.action.up      ; One line up
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_line.exit:
        b     @edkey.action.home    ; Move cursor to home and return



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
        jeq   edkey.action.ins_char.sanity
                                    ; Add character in overwrite mode
        ;-------------------------------------------------------
        ; Sanity check 2 - EOL
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   edkey.action.ins_char.sanity
                                    ; Add character in overwrite mode
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
edkey.action.ins_char_loop:
        movb  *tmp0,*tmp1           ; Move char to the right
        dec   tmp0
        dec   tmp1
        dec   tmp2
        jne   edkey.action.ins_char_loop
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
        ; Add character in overwrite mode
        ;-------------------------------------------------------
edkey.action.ins_char.sanity
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






*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edkey.action.enter:
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.enter.upd_counter
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Update line counter
        ;-------------------------------------------------------
edkey.action.enter.upd_counter:
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Last line in editor buffer?
        jne   edkey.action.newline  ; No, continue newline
        inc   @edb.lines            ; Total lines++
        ;-------------------------------------------------------
        ; Process newline 
        ;-------------------------------------------------------
edkey.action.newline:
        ;-------------------------------------------------------
        ; Scroll 1 line if cursor at bottom row of screen
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   edkey.action.newline.down
        ;-------------------------------------------------------
        ; Scroll
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        jmp   edkey.action.newline.rest
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
edkey.action.newline.down:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Set VDP cursor and save variables
        ;-------------------------------------------------------
edkey.action.newline.rest:
        bl    @fb.get.firstnonblank
        mov   @outparm1,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
        bl    @edb.line.getlength2  ; Get length of new row length
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.newline.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Toggle insert/overwrite mode
*---------------------------------------------------------------
edkey.action.ins_onoff:
        inv   @edb.insmode          ; Toggle insert/overwrite mode
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------
        li    tmp0,2000
edkey.action.ins_onoff.loop:
        dec   tmp0
        jne   edkey.action.ins_onoff.loop
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_onoff.exit: 
        b     @task.vdp.cursor      ; Update cursor shape  




*---------------------------------------------------------------
* Process character
*---------------------------------------------------------------
edkey.action.char:
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        movb  tmp1,@parm1           ; Store character for insert
        mov   @edb.insmode,tmp0     ; Insert or overwrite ?
        jeq   edkey.action.char.overwrite
        ;-------------------------------------------------------
        ; Insert mode
        ;-------------------------------------------------------
edkey.action.char.insert:
        b     @edkey.action.ins_char
        ;-------------------------------------------------------
        ; Overwrite mode
        ;-------------------------------------------------------
edkey.action.char.overwrite:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.current,tmp0      ; Get pointer
        
        movb  @parm1,*tmp0          ; Store character in editor buffer
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh

        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        ;-------------------------------------------------------
        ; Update line length in frame buffer
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jlt   edkey.action.char.exit
                                    ; column < length line ? Skip processing

        mov   @fb.column,@fb.row.length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

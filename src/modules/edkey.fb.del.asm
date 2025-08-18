* FILE......: edkey.fb.del.asm
* Purpose...: Delete related actions in frame buffer pane.

*---------------------------------------------------------------
* Delete character
*---------------------------------------------------------------
edkey.action.del_char:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.del_char.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Get current line in editor buffer
        ;-------------------------------------------------------       
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
        ;-------------------------------------------------------
        ; Assert 1 - Empty line
        ;-------------------------------------------------------
edkey.action.del_char.sanity1:        
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   edkey.action.del_char.exit
                                    ; Exit if empty line
        mov   @fb.current,tmp0      ; Get pointer                                    
        ;-------------------------------------------------------
        ; Assert 2 - Already at EOL
        ;-------------------------------------------------------
edkey.action.del_char.sanity2:        
        mov   tmp2,tmp3             ; \
        dec   tmp3                  ; / tmp3 = line length - 1
        c     @fb.column,tmp3
        jlt   edkey.action.del_char.sanity3
        ;------------------------------------------------------
        ; At EOL - clear current character
        ;------------------------------------------------------        
        clr   tmp1                  ; \ Overwrite with character >00
        movb  tmp1,*tmp0            ; /
        mov   @fb.column,@fb.row.length
                                    ; Row length - 1 
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        jmp  edkey.action.del_char.exit
        ;-------------------------------------------------------
        ; Assert 3 - Abort if row length > 80
        ;-------------------------------------------------------
edkey.action.del_char.sanity3:        
        ci    tmp2,colrow
        jle   edkey.action.del_char.prep
                                    ; Continue if row length <= 80
        ;-----------------------------------------------------------------------
        ; CPU crash
        ;-----------------------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system   
        ;-------------------------------------------------------
        ; Calculate number of characters to move
        ;-------------------------------------------------------
edkey.action.del_char.prep:
        mov   tmp2,tmp3             ; tmp3=line length        
        s     @fb.column,tmp3
        dec   tmp3                  ; Remove base 1 offset 
        a     tmp3,tmp0             ; tmp0=Pointer to last char in line
        mov   tmp0,tmp1
        inc   tmp1                  ; tmp1=tmp0+1
        s     @fb.column,tmp2       ; tmp2=amount of characters to move
        ;-------------------------------------------------------
        ; Setup pointers
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   tmp0,tmp1             ; \ tmp0 = Current character
        inc   tmp1                  ; / tmp1 = Next character
        ;-------------------------------------------------------
        ; Loop from current character until end of line
        ;-------------------------------------------------------
edkey.action.del_char.loop:
        movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
        dec   tmp2
        jne   edkey.action.del_char.loop
        ;-------------------------------------------------------
        ; Special treatment if line 80 characters long
        ;-------------------------------------------------------
        li    tmp2,colrow
        c     @fb.row.length,tmp2
        jne   edkey.action.del_char.save
        dec   tmp0                  ; One time adjustment
        clr   tmp1
        movb  tmp1,*tmp0            ; Write >00 character
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
edkey.action.del_char.save:        
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        dec   @fb.row.length        ; @fb.row.length--
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_char.exit:
        b     @edkey.keyscan.hook.debounce ; Back to editor main


*---------------------------------------------------------------
* Delete until end of line
*---------------------------------------------------------------
edkey.action.del_eol:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.del_eol.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Get current line in editor buffer
        ;-------------------------------------------------------  
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

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
        b     @edkey.keyscan.hook.debounce ; Back to editor main


*---------------------------------------------------------------
* Delete current line
*---------------------------------------------------------------
edkey.action.del_line:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.del_line.exit2
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Get current line in editor buffer
        ;-------------------------------------------------------
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        clr   @fb.row.dirty         ; Discard current line

        mov   @fb.topline,@parm1    ; \
        a     @fb.row,@parm1        ; | Line number to delete (base 1)
        inc   @parm1                ; / 

        ;-------------------------------------------------------
        ; Special handling if at BOT (no real line)
        ;-------------------------------------------------------
        c     @parm1,@edb.lines     ; At BOT in editor buffer?
        jle   edkey.action.del_line.doit 
                                    ; No, is real line. Continue with delete.

        mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)
        bl    @fb.refresh           ; Refresh frame buffer with EB content
                                    ; \ i  @parm1 = Line to start with
                                    ; /
        b     @edkey.action.up      ; Move cursor one line up
        ;-------------------------------------------------------
        ; Delete line in editor buffer
        ;-------------------------------------------------------
edkey.action.del_line.doit:
        bl    @edb.line.del         ; Delete line in editor buffer
                                    ; \ i  @parm1 = Line number to delete
                                    ; /

        c     @parm1,@edb.lines     ; Now at BOT in editor buffer after delete?
        jeq   edkey.action.del_line.refresh
                                    ; Yes, skip get length. No need for garbage.
        ;-------------------------------------------------------
        ; Get length of current row in frame buffer
        ;-------------------------------------------------------
        bl   @edb.line.getlength2   ; Get length of current row
                                    ; \ i  @fb.row        = Current row
                                    ; / o  @fb.row.length = Length of row
        ;-------------------------------------------------------
        ; Refresh frame buffer
        ;-------------------------------------------------------
edkey.action.del_line.refresh:        
        mov   @fb.topline,@parm1    ; Line to start with (becomes @fb.topline)

        bl    @fb.refresh           ; Refresh frame buffer with EB content
                                    ; \ i  @parm1 = Line to start with
                                    ; /

        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Special treatment if current line was last line
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0

        c     tmp0,@edb.lines       ; Was last line?
        jlt   edkey.action.del_line.exit

        b     @edkey.action.up      ; Move cursor one line up        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.del_line.exit:
        b     @edkey.action.home           ; Move cursor to home and return
edkey.action.del_line.exit2:
        b     @edkey.keyscan.hook.debounce ; Back to editor main
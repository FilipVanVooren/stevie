* FILE......: fb.cursor.down.asm
* Purpose...: Move the cursor down 1 line


***************************************************************
* fb.cursor.down
* Logic for moving cursor down 1 line
***************************************************************
* bl @fb.cursor.down
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
fb.cursor.down:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Last line?
        ;------------------------------------------------------
        c     @fb.row,@edb.lines    ; Last line in editor buffer ? 
        jeq   fb.cursor.down.exit
                                    ; Yes, skip further processing
        seto  @fb.status.dirty      ; Trigger refresh of status lines                
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.down.move

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB
                                    
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
fb.cursor.down.move:
        ;-------------------------------------------------------
        ; EOF reached?
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
        jeq   fb.cursor.down.set_cursorx
                                    ; Yes, only position cursor X
        ;-------------------------------------------------------
        ; Check if scrolling required
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   fb.cursor.down.cursor
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        inc   @parm1

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        jmp   fb.cursor.down.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
fb.cursor.down.cursor:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------        
fb.cursor.down.set_cursorx:                
        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row
        
        c     @fb.column,@fb.row.length
        jle   fb.cursor.down.exit  
                                    ; Exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.down.exit:
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
        bl    @vdp.cursor.tat       ; Update cursor
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

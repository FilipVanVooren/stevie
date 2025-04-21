* FILE......: fb.cursor.up.asm
* Purpose...: Move the cursor up 1 line


***************************************************************
* fb.cursor.up
* Move cursor up 1 line
***************************************************************
* bl @fb.cursor.up
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
fb.cursor.up
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Crunch current line if dirty 
        ;-------------------------------------------------------
        seto  @fb.status.dirty      ; Trigger refresh of status lines        
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.up.cursor

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB
                                    
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
fb.cursor.up.cursor:
        mov   @fb.row,tmp0
        jgt   fb.cursor.up.cursor_up
                                    ; Move cursor up if fb.row > 0
        mov   @fb.topline,tmp0      ; Do we need to scroll?
        jeq   fb.cursor.up.set_cursorx
                                    ; At top, only position cursor X
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        dec   tmp0                  ; fb.topline--
        mov   tmp0,@parm1           ; Scroll one line up       

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        jmp   fb.cursor.up.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor up
        ;-------------------------------------------------------
fb.cursor.up.cursor_up:       
        dec   @fb.row               ; Row-- in screen buffer
        bl    @up                   ; Row-- VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------
fb.cursor.up.set_cursorx:
        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row

        c     @fb.column,@fb.row.length
        jle   fb.cursor.up.exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.up.exit:
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
                                    
      .ifeq  spritecursor,0
        bl    @vdp.cursor.tat       ; Update cursor
      .endif     

        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return     

* FILE......: fb.cursor.botscr.asm
* Purpose...: Move cursor to bottom of screen


***************************************************************
* fb.cursor.botscr
* Move cursor to bottom of screen
***************************************************************
* bl @fb.cursor.botscr
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
fb.cursor.botscr:
        dect  stack
        mov   r11,*stack            ; Save return address        
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.botscr.cursor

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Position cursor
        ;-------------------------------------------------------
fb.cursor.botscr.cursor:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        c     @fb.scrrows,@edb.lines
        jgt   fb.cursor.botscr.eof
        mov   @fb.scrrows,tmp0      ; Get bottom row
        jmp   !
        ;-------------------------------------------------------
        ; Cursor at EOF
        ;-------------------------------------------------------
fb.cursor.botscr.eof:
        mov   @edb.lines,tmp0       ; Get last line in file
        ;-------------------------------------------------------
        ; Position cursor
        ;-------------------------------------------------------
!       dec   tmp0                  ; Base 0
        mov   tmp0,@fb.row          ; Frame buffer bottom line
        clr   @fb.column            ; Frame buffer column 0 

        mov   @fb.row,tmp0          ;
        sla   tmp0,8                ; Position cursor
        mov   tmp0,@wyx             ;

        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.botscr.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

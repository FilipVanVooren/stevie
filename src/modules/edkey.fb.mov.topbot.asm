* FILE......: edkey.fb.mov.topbot.asm
* Purpose...: Move to top / bottom in editor buffer

*---------------------------------------------------------------
* Goto top of file
*---------------------------------------------------------------
edkey.action.top:
        bl    @fb.cursor.top        ; Goto top of file
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Goto top of screen
*---------------------------------------------------------------
edkey.action.topscr:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.topscr.refresh

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh screen
        ;-------------------------------------------------------
edkey.action.topscr.refresh:        
        mov   @fb.topline,@parm1    ; Set to top line in frame buffer
        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edkey.action.bot:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.bot.refresh

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.bot.refresh:        
        c     @edb.lines,@fb.scrrows                                    
        jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen

        mov   @edb.lines,tmp0
        s     @fb.scrrows,tmp0
        mov   tmp0,@parm1           ; Set to last page in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.bot.exit:
        jmp   edkey.action.botscr   ; Goto bottom of screen


*---------------------------------------------------------------
* Goto bottom of screen
*---------------------------------------------------------------
edkey.action.botscr:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.botscr.cursor

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Position cursor
        ;-------------------------------------------------------
edkey.action.botscr.cursor:
        seto  @fb.status.dirty      ; Trigger refresh of status lines

        c     @fb.scrrows,@edb.lines
        jgt   edkey.action.botscr.eof
        mov   @fb.scrrows,tmp0      ; Get bottom row
        jmp   !
        ;-------------------------------------------------------
        ; Cursor at EOF
        ;-------------------------------------------------------
edkey.action.botscr.eof:
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
edkey.action.botscr.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce; Back to editor main

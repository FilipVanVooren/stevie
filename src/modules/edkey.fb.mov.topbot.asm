* FILE......: edkey.fb.mov.topbot.asm
* Purpose...: Move to top / bottom in editor buffer

*---------------------------------------------------------------
* Goto top of file
*---------------------------------------------------------------
edkey.action.top:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.top.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.top.refresh:        
        clr   @parm1                ; Set to 1st line in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        b     @ _edkey.goto.fb.toprow
                                    ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer



*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edkey.action.bot:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.bot.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
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

        b     @ _edkey.goto.fb.toprow
                                    ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.bot.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
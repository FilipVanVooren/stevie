* FILE......: edkey.fb.mov.goto.asm
* Purpose...: Goto specified line in editor buffer

*---------------------------------------------------------------
* Goto specified line (@parm1) in editor buffer
*---------------------------------------------------------------
edkey.action.goto:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.goto.refresh

        dect  stack
        mov   @parm1,*stack         ; Push parm1
        bl    @edb.line.pack        ; Copy line to editor buffer
        mov   *stack+,@parm1        ; Pop parm1

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.goto.refresh:        
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        b     @_edkey.goto.fb.toprow ; Position cursor and exit
                                     ; \ i  @parm1 = Line in editor buffer
                                     ; /
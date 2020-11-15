* FILE......: edkey.fb.mov.paging.asm
* Purpose...: Move page up / down in editor buffer

*---------------------------------------------------------------
* Previous page
*---------------------------------------------------------------
edkey.action.ppage:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.ppage.sanity
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
edkey.action.ppage.sanity:        
        mov   @fb.topline,tmp0      ; Exit if already on line 1 
        jeq   edkey.action.ppage.exit
        ;-------------------------------------------------------
        ; Special treatment top page
        ;-------------------------------------------------------
        c     tmp0,@fb.scrrows      ; topline > rows on screen?
        jgt   edkey.action.ppage.topline 
        clr   @fb.topline           ; topline = 0
        jmp   edkey.action.ppage.refresh
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edkey.action.ppage.topline:
        s     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.ppage.refresh:
        mov   @fb.topline,@parm1

        jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ppage.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Next page
*---------------------------------------------------------------
edkey.action.npage:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.npage.sanity
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
edkey.action.npage.sanity:        
        mov   @fb.topline,tmp0
        a     @fb.scrrows,tmp0
        inc   tmp0                  ; Base 1 offset !
        c     tmp0,@edb.lines       ; Exit if on last page
        jgt   edkey.action.npage.exit
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edkey.action.npage.topline:
        a     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.npage.refresh:        
        mov   @fb.topline,@parm1

        jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.npage.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
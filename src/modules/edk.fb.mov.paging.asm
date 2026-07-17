* FILE......: edk.fb.mov.paging.asm
* Purpose...: Move page up / down in editor buffer

*---------------------------------------------------------------
* Previous page
*---------------------------------------------------------------
edk.act.ppage:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edk.act.ppage.sanity

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Assert
        ;-------------------------------------------------------
edk.act.ppage.sanity:        
        mov   @fb.topline,tmp0      ; Exit if already on line 1 
        jeq   edk.act.ppage.exit
        ;-------------------------------------------------------
        ; Special treatment top page
        ;-------------------------------------------------------
        c     tmp0,@fb.scrrows      ; topline > rows on screen?
        jgt   edk.act.ppage.topline 
        clr   @fb.topline           ; topline = 0
        jmp   edk.act.ppage.refresh
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edk.act.ppage.topline:
        s     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edk.act.ppage.refresh:
        mov   @fb.topline,@parm1
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.ppage.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main




*---------------------------------------------------------------
* Next page
*---------------------------------------------------------------
edk.act.npage:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edk.act.npage.sanity

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB
                                    
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Assert
        ;-------------------------------------------------------
edk.act.npage.sanity:        
        mov   @fb.topline,tmp0
        a     @fb.scrrows,tmp0
        inc   tmp0                  ; Base 1 offset !
        c     tmp0,@edb.lines       ; Exit if on last page
        jgt   edk.act.npage.exit
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edk.act.npage.topline:
        a     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edk.act.npage.refresh:        
        mov   @fb.topline,@parm1
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.npage.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

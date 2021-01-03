* FILE......: edkey.fb.mov.updown.asm
* Purpose...: Actions for movement keys in frame buffer pane.

*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
edkey.action.up: 
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Crunch current line if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.up.cursor
        bl    @edb.line.pack.fb     ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
edkey.action.up.cursor:
        mov   @fb.row,tmp0
        jgt   edkey.action.up.cursor_up
                                    ; Move cursor up if fb.row > 0
        mov   @fb.topline,tmp0      ; Do we need to scroll?
        jeq   edkey.action.up.set_cursorx
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
        jmp   edkey.action.up.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor up
        ;-------------------------------------------------------
edkey.action.up.cursor_up:       
        dec   @fb.row               ; Row-- in screen buffer
        bl    @up                   ; Row-- VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------
edkey.action.up.set_cursorx:
        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row

        c     @fb.column,@fb.row.length
        jle   edkey.action.up.exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.up.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
edkey.action.down:
        c     @fb.row,@edb.lines    ; Last line in editor buffer ? 
        jeq   !                     ; Yes, skip further processing
        seto  @fb.status.dirty      ; Trigger refresh of status lines                
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.down.move
        bl    @edb.line.pack.fb     ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
edkey.action.down.move:
        ;-------------------------------------------------------
        ; EOF reached?
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
        jeq   edkey.action.down.set_cursorx
                                    ; Yes, only position cursor X
        ;-------------------------------------------------------
        ; Check if scrolling required
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   edkey.action.down.cursor
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        inc   @parm1

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        jmp   edkey.action.down.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
edkey.action.down.cursor:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------        
edkey.action.down.set_cursorx:                
        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row
        
        c     @fb.column,@fb.row.length
        jle   edkey.action.down.exit  
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
edkey.action.down.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!       b     @hook.keyscan.bounce  ; Back to editor main

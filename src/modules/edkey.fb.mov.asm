* FILE......: edkey.fb.mov.asm
* Purpose...: Actions for movement keys in frame buffer pane.


*---------------------------------------------------------------
* Cursor left
*---------------------------------------------------------------
edkey.action.left:
        mov   @fb.column,tmp0
        jeq   !                     ; column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        dec   @fb.column            ; Column-- in screen buffer
        dec   @wyx                  ; Column-- VDP cursor
        dec   @fb.current
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Cursor right
*---------------------------------------------------------------
edkey.action.right:
        c     @fb.column,@fb.row.length
        jhe   !                     ; column > length line ? Skip processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        inc   @fb.current  
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
edkey.action.up: 
        ;-------------------------------------------------------
        ; Crunch current line if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.up.cursor
        bl    @edb.line.pack        ; Copy line to editor buffer
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
        mov   tmp0,@parm1
        bl    @fb.refresh           ; Scroll one line up
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
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.down.move
        bl    @edb.line.pack        ; Copy line to editor buffer
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
        bl    @fb.refresh
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



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.home:
        mov   @wyx,tmp0
        andi  tmp0,>ff00
        mov   tmp0,@wyx             ; VDP cursor column=0
        clr   @fb.column
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.end:
        mov   @fb.row.length,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set VDP cursor column position
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main




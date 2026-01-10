* FILE......: edkey.fb.mov.leftright.asm
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
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        clr   @fb.curtoggle         ; \ Turn cursor on
        bl    @task.vdp.cursor      ; / Update VDP cursor shape
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


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
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        clr   @fb.curtoggle         ; \ Turn cursor on
        bl    @task.vdp.cursor      ; / Update VDP cursor shape
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.home:
        bl    @fb.cursor.home       ; Move cursor to beginning of line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.end:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        mov   @fb.row.length,tmp0   ; \ Get row length
        ci    tmp0,80               ; | Adjust if necessary, normally cursor
        jlt   !                     ; | is right of last character on line,
        li    tmp0,79               ; / except if 80 characters on line.
        ;-------------------------------------------------------
        ; Set cursor X position
        ;-------------------------------------------------------
!       mov   tmp0,@fb.column       ; Set X position, cursor following char.        
        bl    @xsetx                ; Set VDP cursor column position
        
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

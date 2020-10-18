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
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.home:
        mov   @wyx,tmp0
        andi  tmp0,>ff00            ; Reset cursor X position to 0
        mov   tmp0,@wyx             ; VDP cursor column=0
        clr   @fb.column
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.end:
        mov   @fb.row.length,tmp0   ; \ Get row length
        ci    tmp0,80               ; | Adjust if necessary, normally cursor
        jlt   !                     ; | is right of last character on line,
        li    tmp0,79               ; / except if 80 characters on line.
        ;-------------------------------------------------------
        ; Set cursor X position
        ;-------------------------------------------------------
!       mov   tmp0,@fb.column       ; Set X position, cursor following char.        
        bl    @xsetx                ; Set VDP cursor column position
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main

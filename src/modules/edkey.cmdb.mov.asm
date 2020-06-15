* FILE......: edkey.cmdb.mov.asm
* Purpose...: Actions for movement keys in command buffer pane.


*---------------------------------------------------------------
* Cursor left
*---------------------------------------------------------------
edkey.action.cmdb.left:
        mov   @cmdb.column,tmp0
        jeq   !                     ; column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        dec   @cmdb.column          ; Column-- in command buffer
        dec   @wyx                  ; Column-- VDP cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Cursor right
*---------------------------------------------------------------
edkey.action.cmdb.right:
        c     @cmdb.column,@cmdb.length
        jhe   !                     ; column > length line ? Skip processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        inc   @cmdb.column          ; Column++ in command buffer
        inc   @wyx                  ; Column++ VDP cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.cmdb.home:
        bl    @setx
              data 0                 ; VDP cursor column=0
        clr   @cmdb.column
        b     @hook.keyscan.bounce   ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.cmdb.end:
        mov   @fb.row.length,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                 ; Set VDP cursor column position
        b     @hook.keyscan.bounce   ; Back to editor main
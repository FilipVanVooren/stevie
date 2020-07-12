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
        dec   @cmdb.cursor          ; Column-- CMDB cursor
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
        inc   @cmdb.cursor          ; Column++ CMDB cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.cmdb.home:
        li    tmp0,1
        mov   tmp0,@cmdb.column      ; First column

        movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
        mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
        
        b     @hook.keyscan.bounce   ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.cmdb.end:
        mov   @fb.row.length,tmp0
        mov   tmp0,@fb.column
        b     @hook.keyscan.bounce   ; Back to editor main
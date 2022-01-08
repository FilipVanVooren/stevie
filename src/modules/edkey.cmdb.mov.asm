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
!       b     @edkey.keyscan.hook.bounce  ; Back to editor main


*---------------------------------------------------------------
* Cursor right
*---------------------------------------------------------------
edkey.action.cmdb.right:
        bl    @cmdb.cmd.getlength
        c     @cmdb.column,@outparm1
        jhe   !                     ; column > length line ? Skip processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        inc   @cmdb.column          ; Column++ in command buffer
        inc   @cmdb.cursor          ; Column++ CMDB cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!       b     @edkey.keyscan.hook.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.cmdb.home:
        clr   tmp0
        mov   tmp0,@cmdb.column      ; First column
        inc   tmp0
        movb  @cmdb.cursor,tmp0      ; Get CMDB cursor position
        mov   tmp0,@cmdb.cursor      ; Reposition CMDB cursor
        
        b     @edkey.keyscan.hook.bounce   ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.cmdb.end:
        movb  @cmdb.cmdlen,tmp0      ; Get length byte of current command
        srl   tmp0,8                 ; Right justify
        mov   tmp0,@cmdb.column      ; Save column position
        inc   tmp0                   ; One time adjustment command prompt        
        ai    tmp0,>1a00             ; Y=26
        mov   tmp0,@cmdb.cursor      ; Set cursor position
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
        b     @edkey.keyscan.hook.bounce   ; Back to editor main
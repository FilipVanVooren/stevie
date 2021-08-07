* FILE......: edkey.fb.mov.updown.asm
* Purpose...: Actions for movement keys in frame buffer pane.

*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
edkey.action.up: 
        bl    @fb.cursor.up         ; Move cursor up
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.up.exit:
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
edkey.action.down:
        bl    @fb.cursor.down       ; Move cursor down
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.down.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
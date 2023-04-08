* FILE......: edkey.fb.mov.updown.asm
* Purpose...: Actions for movement keys in frame buffer pane

*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
edkey.action.up: 
        bl    @fb.cursor.up         ; Move cursor up
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
edkey.action.down:
        bl    @fb.cursor.down       ; Move cursor down
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

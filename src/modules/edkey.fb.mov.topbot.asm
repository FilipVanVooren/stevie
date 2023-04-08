* FILE......: edkey.fb.mov.topbot.asm
* Purpose...: Move to top / bottom in editor buffer

*---------------------------------------------------------------
* Goto top of file
*---------------------------------------------------------------
edkey.action.top:
        bl    @fb.cursor.top        ; Goto top of file
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto top of screen
*---------------------------------------------------------------
edkey.action.topscr:
        bl    @fb.cursor.topscr     ; Goto top of screen
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edkey.action.bot:
        bl    @fb.cursor.bot        ; Goto bottom of file
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto bottom of screen
*---------------------------------------------------------------
edkey.action.botscr:
        bl    @fb.cursor.botscr     ; Goto bottom of screen
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

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

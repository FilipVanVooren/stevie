* FILE......: edk.fb.mov.topbot.asm
* Purpose...: Move to top / bottom in editor buffer

*---------------------------------------------------------------
* Goto top of file
*---------------------------------------------------------------
edk.act.top:
        bl    @fb.cursor.top        ; Goto top of file
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto top of screen
*---------------------------------------------------------------
edk.act.topscr:
        bl    @fb.cursor.topscr     ; Goto top of screen
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edk.act.bot:
        bl    @fb.cursor.bot        ; Goto bottom of file
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Goto bottom of screen
*---------------------------------------------------------------
edk.act.botscr:
        bl    @fb.cursor.botscr     ; Goto bottom of screen
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
edk.act.up: 
        bl    @fb.cursor.up         ; Move cursor up
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
edk.act.down:
        bl    @fb.cursor.down       ; Move cursor down
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

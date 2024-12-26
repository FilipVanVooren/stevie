* FILE......: edkey.fb.mov.asm
* Purpose...: Actions for moving to search matches in frame buffer pane.

*---------------------------------------------------------------
* Cursor on previous match
*---------------------------------------------------------------
edkey.action.goto.pmatch:
        abs   @edb.srch.matches            ; Any search matches?
        jeq   !                            ; No, exit early
        bl    @fb.goto.prevmatch           ; Goto previous match 
!       b     @edkey.keyscan.hook.debounce ; Back to editor main


*---------------------------------------------------------------
* Cursor on next match
*---------------------------------------------------------------
edkey.action.goto.nmatch:
        abs   @edb.srch.matches            ; Any search matches?
        jeq   !                            ; No, goto line 1
        bl    @fb.goto.nextmatch           ; Goto next match
!       b     @edkey.keyscan.hook.debounce ; Back to editor main

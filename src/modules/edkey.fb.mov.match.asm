* FILE......: edkey.fb.mov.asm
* Purpose...: Actions for moving to search matches in frame buffer pane.

*---------------------------------------------------------------
* Cursor on previous match (or goto previous file)
*---------------------------------------------------------------
edkey.action.goto.pmatch:
        abs   @edb.srch.matches            ; Any search matches?
        jeq   edkey.action.goto.prevfile   ; No, goto previous file
        bl    @fb.goto.prevmatch           ; Goto previous match 
!       b     @edkey.keyscan.hook.debounce ; Back to editor main
edkey.action.goto.prevfile:
        b     @edkey.action.fb.file.prev   ; Goto previous file


*---------------------------------------------------------------
* Cursor on next match (or goto next file)
*---------------------------------------------------------------
edkey.action.goto.nmatch:
        abs   @edb.srch.matches            ; Any search matches?
        jeq   edkey.action.goto.nextfile   ; No, goto next file
        bl    @fb.goto.nextmatch           ; Goto next match
!       b     @edkey.keyscan.hook.debounce ; Back to editor main
edkey.action.goto.nextfile:
        b     @edkey.action.fb.file.prev   ; Goto next file

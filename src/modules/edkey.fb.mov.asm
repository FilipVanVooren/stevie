* FILE......: edkey.fb.mov.asm
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
* Cursor up
*---------------------------------------------------------------
edkey.action.up: 
        ;-------------------------------------------------------
        ; Crunch current line if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.up.cursor
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
edkey.action.up.cursor:
        mov   @fb.row,tmp0
        jgt   edkey.action.up.cursor_up
                                    ; Move cursor up if fb.row > 0
        mov   @fb.topline,tmp0      ; Do we need to scroll?
        jeq   edkey.action.up.set_cursorx
                                    ; At top, only position cursor X
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        dec   tmp0                  ; fb.topline--
        mov   tmp0,@parm1
        bl    @fb.refresh           ; Scroll one line up
        jmp   edkey.action.up.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor up
        ;-------------------------------------------------------
edkey.action.up.cursor_up:       
        dec   @fb.row               ; Row-- in screen buffer
        bl    @up                   ; Row-- VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------
edkey.action.up.set_cursorx:
        bl    @edb.line.getlength2  ; Get length current line
        c     @fb.column,@fb.row.length
        jle   edkey.action.up.exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.up.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
edkey.action.down:
        c     @fb.row,@edb.lines    ; Last line in editor buffer ? 
        jeq   !                     ; Yes, skip further processing
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.down.move
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
edkey.action.down.move:
        ;-------------------------------------------------------
        ; EOF reached?
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
        jeq   edkey.action.down.set_cursorx
                                    ; Yes, only position cursor X
        ;-------------------------------------------------------
        ; Check if scrolling required
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   edkey.action.down.cursor
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        jmp   edkey.action.down.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
edkey.action.down.cursor:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------        
edkey.action.down.set_cursorx:                
        bl    @edb.line.getlength2  ; Get length current line
        
        c     @fb.column,@fb.row.length
        jle   edkey.action.down.exit  
                                    ; Exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.down.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!       b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
edkey.action.home:
        mov   @wyx,tmp0
        andi  tmp0,>ff00
        mov   tmp0,@wyx             ; VDP cursor column=0
        clr   @fb.column
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce              ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
edkey.action.end:
        mov   @fb.row.length,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set VDP cursor column position
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @hook.keyscan.bounce              ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of word or previous word
*---------------------------------------------------------------
edkey.action.pword:
        mov   @fb.column,tmp0
        jeq   !                     ; column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Prepare 2 char buffer
        ;-------------------------------------------------------
        mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
        seto  tmp3                  ; Fill 2 char buffer with >ffff
        jmp   edkey.action.pword_scan_char
        ;-------------------------------------------------------
        ; Scan backwards to first character following space
        ;-------------------------------------------------------
edkey.action.pword_scan
        dec   tmp1
        dec   tmp0                  ; Column-- in screen buffer
        jeq   edkey.action.pword_done
                                    ; Column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Check character 
        ;-------------------------------------------------------
edkey.action.pword_scan_char
        movb  *tmp1,tmp2            ; Get character
        srl   tmp3,8                ; Shift-out old character in buffer
        movb  tmp2,tmp3             ; Shift-in new character in buffer
        srl   tmp2,8                ; Right justify
        ci    tmp2,32               ; Space character found?
        jne   edkey.action.pword_scan
                                    ; No space found, try again
        ;-------------------------------------------------------
        ; Space found, now look closer
        ;-------------------------------------------------------
        ci    tmp3,>2020            ; current and previous char both spaces?
        jeq   edkey.action.pword_scan
                                    ; Yes, so continue scanning
        ci    tmp3,>20ff            ; First character is space
        jeq   edkey.action.pword_scan
        ;-------------------------------------------------------
        ; Check distance travelled
        ;-------------------------------------------------------
        mov   @fb.column,tmp3       ; re-use tmp3 
        s     tmp0,tmp3
        ci    tmp3,2                ; Did we move at least 2 positions?
        jlt   edkey.action.pword_scan
                                    ; Didn't move enough so keep on scanning
        ;--------------------------------------------------------
        ; Set cursor following space
        ;--------------------------------------------------------
        inc   tmp1              
        inc   tmp0                  ; Column++ in screen buffer
        ;-------------------------------------------------------
        ; Save position and position hardware cursor
        ;-------------------------------------------------------
edkey.action.pword_done:
        mov   tmp1,@fb.current 
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.pword.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!       b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Cursor next word
*---------------------------------------------------------------
edkey.action.nword:
        clr   tmp4                  ; Reset multiple spaces mode
        mov   @fb.column,tmp0
        c     tmp0,@fb.row.length
        jhe   !                     ; column=last char ? Skip further processing
        ;-------------------------------------------------------
        ; Prepare 2 char buffer
        ;-------------------------------------------------------
        mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
        seto  tmp3                  ; Fill 2 char buffer with >ffff
        jmp   edkey.action.nword_scan_char
        ;-------------------------------------------------------
        ; Multiple spaces mode
        ;-------------------------------------------------------
edkey.action.nword_ms:
        seto  tmp4                  ; Set multiple spaces mode
        ;-------------------------------------------------------
        ; Scan forward to first character following space
        ;-------------------------------------------------------
edkey.action.nword_scan
        inc   tmp1
        inc   tmp0                  ; Column++ in screen buffer
        c     tmp0,@fb.row.length
        jeq   edkey.action.nword_done
                                    ; Column=last char ? Skip further processing
        ;-------------------------------------------------------
        ; Check character 
        ;-------------------------------------------------------
edkey.action.nword_scan_char
        movb  *tmp1,tmp2            ; Get character
        srl   tmp3,8                ; Shift-out old character in buffer
        movb  tmp2,tmp3             ; Shift-in new character in buffer
        srl   tmp2,8                ; Right justify

        ci    tmp4,>ffff            ; Multiple space mode on?
        jne   edkey.action.nword_scan_char_other 
        ;-------------------------------------------------------
        ; Special handling if multiple spaces found
        ;-------------------------------------------------------
edkey.action.nword_scan_char_ms:
        ci    tmp2,32               
        jne   edkey.action.nword_done
                                    ; Exit if non-space found 
        jmp   edkey.action.nword_scan
        ;-------------------------------------------------------
        ; Normal handling
        ;-------------------------------------------------------
edkey.action.nword_scan_char_other:
        ci    tmp2,32               ; Space character found?
        jne   edkey.action.nword_scan
                                    ; No space found, try again
        ;-------------------------------------------------------
        ; Space found, now look closer
        ;-------------------------------------------------------
        ci    tmp3,>2020            ; current and previous char both spaces?
        jeq   edkey.action.nword_ms
                                    ; Yes, so continue scanning
        ci    tmp3,>20ff            ; First characer is space?
        jeq   edkey.action.nword_scan
        ;--------------------------------------------------------
        ; Set cursor following space
        ;--------------------------------------------------------
        inc   tmp1              
        inc   tmp0                  ; Column++ in screen buffer
        ;-------------------------------------------------------
        ; Save position and position hardware cursor
        ;-------------------------------------------------------
edkey.action.nword_done:
        mov   tmp1,@fb.current 
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.nword.exit:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!       b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Previous page
*---------------------------------------------------------------
edkey.action.ppage:
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0      ; Exit if already on line 1 
        jeq   edkey.action.ppage.exit
        ;-------------------------------------------------------
        ; Special treatment top page
        ;-------------------------------------------------------
        c     tmp0,@fb.scrrows      ; topline > rows on screen?
        jgt   edkey.action.ppage.topline 
        clr   @fb.topline           ; topline = 0
        jmp   edkey.action.ppage.crunch
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edkey.action.ppage.topline:
        s     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
edkey.action.ppage.crunch:
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.ppage.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.ppage.refresh:
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ppage.exit:
        clr   @fb.row
        clr   @fb.column
        clr   @wyx                  ; Set VDP cursor on row 0, column 0
        b     @edkey.action.up      ; In edkey.action up cursor is moved up



*---------------------------------------------------------------
* Next page
*---------------------------------------------------------------
edkey.action.npage:
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.scrrows,tmp0
        c     tmp0,@edb.lines       ; Exit if on last page
        jgt   edkey.action.npage.exit
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
edkey.action.npage.topline:
        a     @fb.scrrows,@fb.topline         
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
edkey.action.npage.crunch:
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.npage.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.npage.refresh:        
        b     @edkey.action.ppage.refresh
                                    ; Same logic as previous page
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.npage.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Goto top of file
*---------------------------------------------------------------
edkey.action.top:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.top.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.top.refresh:        
        clr   @fb.topline           ; Set to 1st line in editor buffer
        clr   @parm1
        bl    @fb.refresh           ; Refresh frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.top.exit:
        clr   @fb.row               ; Frame buffer line 0
        clr   @fb.column            ; Frame buffer column 0
        clr   @wyx                  ; Set VDP cursor on row 0, column 0
        b     @hook.keyscan.bounce  ; Back to editor main



*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edkey.action.bot:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.bot.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.bot.refresh:        
        c     @edb.lines,@fb.scrrows
                                    ; Skip if whole editor buffer on screen
        jle   !
        mov   @edb.lines,tmp0
        s     @fb.scrrows,tmp0
        mov   tmp0,@fb.topline      ; Set to last page in editor buffer
        mov   tmp0,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.bot.exit:
        clr   @fb.row               ; Editor line 0
        clr   @fb.column            ; Editor column 0
        li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
        mov   tmp0,@wyx             ; Set cursor
!       b     @hook.keyscan.bounce  ; Back to editor main
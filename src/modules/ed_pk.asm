* FILE......: ed_pk.asm
* Purpose...: Editor Process Key


*---------------------------------------------------------------
* Movement keys
*---------------------------------------------------------------
key_left      equ >0800                      ; fnctn + s
key_right     equ >0900                      ; fnctn + d
key_up        equ >0b00                      ; fnctn + e
key_down      equ >0a00                      ; fnctn + x
key_home      equ >8100                      ; ctrl  + a
key_end       equ >8600                      ; ctrl  + f 
key_pword     equ >9300                      ; ctrl  + s
key_nword     equ >8400                      ; ctrl  + d
key_ppage     equ >8500                      ; ctrl  + e
key_npage     equ >9800                      ; ctrl  + x
*---------------------------------------------------------------
* Modifier keys
*---------------------------------------------------------------
key_enter       equ >0d00                    ; enter
key_del_char    equ >0300                    ; fnctn + 1 
key_del_line    equ >0700                    ; fnctn + 3
key_del_eol     equ >8b00                    ; ctrl  + k
key_ins_char    equ >0400                    ; fnctn + 2
key_ins_onoff   equ >b200                    ; ctrl  + 2
key_ins_line    equ >0e00                    ; fnctn + 5
key_quit1       equ >0500                    ; fnctn + +
key_quit2       equ >9d00                    ; ctrl  + +
*---------------------------------------------------------------
* Action keys mapping <-> actions table
*---------------------------------------------------------------
keymap_actions
        ;-------------------------------------------------------
        ; Movement keys
        ;-------------------------------------------------------
        data  key_enter,ed_pk.action.enter          ; New line
        data  key_left,ed_pk.action.left            ; Move cursor left
        data  key_right,ed_pk.action.right          ; Move cursor right
        data  key_up,ed_pk.action.up                ; Move cursor up
        data  key_down,ed_pk.action.down            ; Move cursor down
        data  key_home,ed_pk.action.home            ; Move cursor to line begin
        data  key_end,ed_pk.action.end              ; Move cursor to line end
        data  key_pword,ed_pk.action.pword          ; Move cursor previous word
        data  key_nword,ed_pk.action.nword          ; Move cursor next word
        data  key_ppage,ed_pk.action.ppage          ; Move cursor previous page
        data  key_npage,ed_pk.action.npage          ; Move cursor next page
        ;-------------------------------------------------------
        ; Modifier keys - Delete
        ;-------------------------------------------------------
        data  key_del_char,ed_pk.action.del_char    ; Delete character
        data  key_del_eol,ed_pk.action.del_eol      ; Delete until end of line
        data  key_del_line,ed_pk.action.del_line    ; Delete current line
        ;-------------------------------------------------------
        ; Modifier keys - Insert
        ;-------------------------------------------------------
        data  key_ins_char,ed_pk.action.ins_char.ws ; Insert whitespace
        data  key_ins_onoff,ed_pk.action.ins_onoff  ; Insert mode on/off
        data  key_ins_line,ed_pk.action.ins_line    ; Insert new line
        ;-------------------------------------------------------
        ; Other action keys
        ;-------------------------------------------------------
        data  key_quit1,ed_pk.action.quit           ; Quit TiVi
        data  >ffff                                 ; EOL



****************************************************************
* Editor - Process key
****************************************************************
ed_pk   mov   @waux1,tmp1           ; Get key value
        andi  tmp1,>ff00            ; Get rid of LSB

        li    tmp2,keymap_actions   ; Load keyboard map
        seto  tmp3                  ; EOL marker
        ;-------------------------------------------------------
        ; Iterate over keyboard map for matching key
        ;-------------------------------------------------------
ed_pk.check_next_key:
        c     *tmp2,tmp3            ; EOL reached ?
        jeq   ed_pk.do_action.set   ; Yes, so go add letter

        c     tmp1,*tmp2+           ; Key matched?
        jeq   ed_pk.do_action       ; Yes, do action
        inct  tmp2                  ; No, skip action
        jmp   ed_pk.check_next_key  ; Next key

ed_pk.do_action:
        mov  *tmp2,tmp2             ; Get action address
        b    *tmp2                  ; Process key action
ed_pk.do_action.set:
        b    @ed_pk.action.char     ; Add character to buffer
        


*---------------------------------------------------------------
* Quit
*---------------------------------------------------------------
ed_pk.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit


*---------------------------------------------------------------
* Cursor left
*---------------------------------------------------------------
ed_pk.action.left:
        mov   @fb.column,tmp0
        jeq   !jmp2b                ; column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        dec   @fb.column            ; Column-- in screen buffer
        dec   @wyx                  ; Column-- VDP cursor
        dec   @fb.current
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!jmp2b  b     @ed_wait              ; Back to editor main


*---------------------------------------------------------------
* Cursor right
*---------------------------------------------------------------
ed_pk.action.right:
        c     @fb.column,@fb.row.length
        jhe   !jmp2b                ; column > length line ? Skip further processing
        ;-------------------------------------------------------
        ; Update
        ;-------------------------------------------------------
        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        inc   @fb.current  
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
!jmp2b  b     @ed_wait              ; Back to editor main


*---------------------------------------------------------------
* Cursor up
*---------------------------------------------------------------
ed_pk.action.up: 
        ;-------------------------------------------------------
        ; Crunch current line if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.up.cursor
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
ed_pk.action.up.cursor:
        mov   @fb.row,tmp0
        jgt   ed_pk.action.up.cursor_up
                                    ; Move cursor up if fb.row>0
        mov   @fb.topline,tmp0      ; Do we need to scroll?
        jeq   ed_pk.action.up.set_cursorx
                                    ; At top, only position cursor X
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        dec   tmp0                  ; fb.topline--
        mov   tmp0,@parm1
        bl    @fb.refresh           ; Scroll one line up
        jmp   ed_pk.action.up.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor up
        ;-------------------------------------------------------
ed_pk.action.up.cursor_up:       
        dec   @fb.row               ; Row-- in screen buffer
        bl    @up                   ; Row-- VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------
ed_pk.action.up.set_cursorx:
        bl    @edb.line.getlength2  ; Get length current line
        c     @fb.column,@fb.row.length
        jle   ed_pk.action.up.$$
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.up.$$:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Cursor down
*---------------------------------------------------------------
ed_pk.action.down:
        c     @fb.row,@edb.lines    ; Last line in editor buffer ? 
        jeq   !jmp2b                ; Yes, skip further processing
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.down.move
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Move cursor
        ;-------------------------------------------------------
ed_pk.action.down.move:
        ;-------------------------------------------------------
        ; EOF reached?
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     @edb.lines,tmp0       ; fb.topline + fb.row = edb.lines ?
        jeq   ed_pk.action.down.set_cursorx
                                    ; Yes, only position cursor X
        ;-------------------------------------------------------
        ; Check if scrolling required
        ;-------------------------------------------------------
        mov   @fb.screenrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   ed_pk.action.down.cursor
        ;-------------------------------------------------------
        ; Scroll 1 line
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        jmp   ed_pk.action.down.set_cursorx
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
ed_pk.action.down.cursor:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Check line length and position cursor
        ;-------------------------------------------------------        
ed_pk.action.down.set_cursorx:                
        bl    @edb.line.getlength2  ; Get length current line
        c     @fb.column,@fb.row.length
        jle   ed_pk.action.down.$$  ; Exit
        ;-------------------------------------------------------
        ; Adjust cursor column position
        ;-------------------------------------------------------
        mov   @fb.row.length,@fb.column 
        mov   @fb.column,tmp0
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.down.$$:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!jmp2b  b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of line
*---------------------------------------------------------------
ed_pk.action.home:
        mov   @wyx,tmp0
        andi  tmp0,>ff00
        mov   tmp0,@wyx             ; VDP cursor column=0
        clr   @fb.column
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @ed_wait              ; Back to editor main

*---------------------------------------------------------------
* Cursor end of line
*---------------------------------------------------------------
ed_pk.action.end:
        mov   @fb.row.length,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set VDP cursor column position
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Cursor beginning of word or previous word
*---------------------------------------------------------------
ed_pk.action.pword:
        mov   @fb.column,tmp0
        jeq   !jmp2b                ; column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Prepare 2 char buffer
        ;-------------------------------------------------------
        mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
        seto  tmp3                  ; Fill 2 char buffer with >ffff
        jmp   ed_pk.action.pword_scan_char
        ;-------------------------------------------------------
        ; Scan backwards to first character following space
        ;-------------------------------------------------------
ed_pk.action.pword_scan
        dec   tmp1
        dec   tmp0                  ; Column-- in screen buffer
        jeq   ed_pk.action.pword_done
                                    ; Column=0 ? Skip further processing
        ;-------------------------------------------------------
        ; Check character 
        ;-------------------------------------------------------
ed_pk.action.pword_scan_char
        movb  *tmp1,tmp2            ; Get character
        srl   tmp3,8                ; Shift-out old character in buffer
        movb  tmp2,tmp3             ; Shift-in new character in buffer
        srl   tmp2,8                ; Right justify
        ci    tmp2,32               ; Space character found?
        jne   ed_pk.action.pword_scan
                                    ; No space found, try again
        ;-------------------------------------------------------
        ; Space found, now look closer
        ;-------------------------------------------------------
        ci    tmp3,>2020            ; current and previous char both spaces?
        jeq   ed_pk.action.pword_scan
                                    ; Yes, so continue scanning
        ci    tmp3,>20ff            ; First character is space
        jeq   ed_pk.action.pword_scan
        ;-------------------------------------------------------
        ; Check distance travelled
        ;-------------------------------------------------------
        mov   @fb.column,tmp3       ; re-use tmp3 
        s     tmp0,tmp3
        ci    tmp3,2                ; Did we move at least 2 positions?
        jlt   ed_pk.action.pword_scan
                                    ; Didn't move enough so keep on scanning
        ;--------------------------------------------------------
        ; Set cursor following space
        ;--------------------------------------------------------
        inc   tmp1              
        inc   tmp0                  ; Column++ in screen buffer
        ;-------------------------------------------------------
        ; Save position and position hardware cursor
        ;-------------------------------------------------------
ed_pk.action.pword_done:
        mov   tmp1,@fb.current 
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.pword.$$:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!jmp2b  b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Cursor next word
*---------------------------------------------------------------
ed_pk.action.nword:
        clr   tmp4                  ; Reset multiple spaces mode
        mov   @fb.column,tmp0
        c     tmp0,@fb.row.length
        jhe   !jmp2b                ; column=last char ? Skip further processing
        ;-------------------------------------------------------
        ; Prepare 2 char buffer
        ;-------------------------------------------------------
        mov   @fb.current,tmp1      ; Get pointer to char in frame buffer
        seto  tmp3                  ; Fill 2 char buffer with >ffff
        jmp   ed_pk.action.nword_scan_char
        ;-------------------------------------------------------
        ; Multiple spaces mode
        ;-------------------------------------------------------
ed_pk.action.nword_ms:
        seto  tmp4                  ; Set multiple spaces mode
        ;-------------------------------------------------------
        ; Scan forward to first character following space
        ;-------------------------------------------------------
ed_pk.action.nword_scan
        inc   tmp1
        inc   tmp0                  ; Column++ in screen buffer
        c     tmp0,@fb.row.length
        jeq   ed_pk.action.nword_done
                                    ; Column=last char ? Skip further processing
        ;-------------------------------------------------------
        ; Check character 
        ;-------------------------------------------------------
ed_pk.action.nword_scan_char
        movb  *tmp1,tmp2            ; Get character
        srl   tmp3,8                ; Shift-out old character in buffer
        movb  tmp2,tmp3             ; Shift-in new character in buffer
        srl   tmp2,8                ; Right justify

        ci    tmp4,>ffff            ; Multiple space mode on?
        jne   ed_pk.action.nword_scan_char_other 
        ;-------------------------------------------------------
        ; Special handling if multiple spaces found
        ;-------------------------------------------------------
ed_pk.action.nword_scan_char_ms:
        ci    tmp2,32               
        jne   ed_pk.action.nword_done
                                    ; Exit if non-space found 
        jmp   ed_pk.action.nword_scan
        ;-------------------------------------------------------
        ; Normal handling
        ;-------------------------------------------------------
ed_pk.action.nword_scan_char_other:
        ci    tmp2,32               ; Space character found?
        jne   ed_pk.action.nword_scan
                                    ; No space found, try again
        ;-------------------------------------------------------
        ; Space found, now look closer
        ;-------------------------------------------------------
        ci    tmp3,>2020            ; current and previous char both spaces?
        jeq   ed_pk.action.nword_ms
                                    ; Yes, so continue scanning
        ci    tmp3,>20ff            ; First characer is space?
        jeq   ed_pk.action.nword_scan
        ;--------------------------------------------------------
        ; Set cursor following space
        ;--------------------------------------------------------
        inc   tmp1              
        inc   tmp0                  ; Column++ in screen buffer
        ;-------------------------------------------------------
        ; Save position and position hardware cursor
        ;-------------------------------------------------------
ed_pk.action.nword_done:
        mov   tmp1,@fb.current 
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.nword.$$:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
!jmp2b  b     @ed_wait              ; Back to editor main




*---------------------------------------------------------------
* Previous page
*---------------------------------------------------------------
ed_pk.action.ppage:
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0      ; Exit if already on line 1 
        jeq   ed_pk.action.ppage.$$
        ;-------------------------------------------------------
        ; Special treatment top page
        ;-------------------------------------------------------
        c     tmp0,@fb.screenrows   ; topline > rows on screen?
        jgt   ed_pk.action.ppage.topline 
        clr   @fb.topline           ; topline = 0
        jmp   ed_pk.action.ppage.crunch
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
ed_pk.action.ppage.topline:
        s     @fb.screenrows,@fb.topline         
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
ed_pk.action.ppage.crunch:
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.ppage.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
ed_pk.action.ppage.refresh:
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.ppage.$$:
        clr   @fb.row
        inc   @fb.row               ; Set fb.row=1
        clr   @fb.column
        li    tmp0,>0100            ; Set VDP cursor on line 1, column 0
        mov   tmp0,@wyx             ; In ed_pk.action up cursor is moved up
        b     @ed_pk.action.up      ; Do rest of logic



*---------------------------------------------------------------
* Next page
*---------------------------------------------------------------
ed_pk.action.npage:
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.screenrows,tmp0
        c     tmp0,@edb.lines       ; Exit if on last page
        jgt   ed_pk.action.npage.$$
        ;-------------------------------------------------------
        ; Adjust topline
        ;-------------------------------------------------------
ed_pk.action.npage.topline:
        a     @fb.screenrows,@fb.topline         
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
ed_pk.action.npage.crunch:
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.npage.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
ed_pk.action.npage.refresh:        
        b     @ed_pk.action.ppage.refresh
                                    ; Same logic as previous pabe
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.npage.$$:
        b     @ed_wait              ; Back to editor main


*---------------------------------------------------------------
* Delete character
*---------------------------------------------------------------
ed_pk.action.del_char:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Sanity check 1
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   ed_pk.action.del_char.$$
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Sanity check 2
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   ed_pk.action.del_char.$$
                                    ; Exit if at EOL
        ;-------------------------------------------------------
        ; Prepare for delete operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   tmp0,tmp1             ; Add 1 to pointer
        inc   tmp1               
        ;-------------------------------------------------------
        ; Loop until end of line
        ;-------------------------------------------------------
ed_pk.action.del_char_loop:
        movb  *tmp1+,*tmp0+         ; Overwrite current char with next char
        dec   tmp2
        jne   ed_pk.action.del_char_loop
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        dec   @fb.row.length        ; @fb.row.length--
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.del_char.$$:
        b     @ed_wait              ; Back to editor main


*---------------------------------------------------------------
* Delete until end of line
*---------------------------------------------------------------
ed_pk.action.del_eol:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   ed_pk.action.del_eol.$$
                                    ; Exit if empty line
        ;-------------------------------------------------------
        ; Prepare for erase operation
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.colsline,tmp2
        s     @fb.column,tmp2
        clr   tmp1
        ;-------------------------------------------------------
        ; Loop until last column in frame buffer
        ;-------------------------------------------------------
ed_pk.action.del_eol_loop:
        movb  tmp1,*tmp0+           ; Overwrite current char with >00
        dec   tmp2
        jne   ed_pk.action.del_eol_loop
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh

        mov   @fb.column,@fb.row.length
                                    ; Set new row length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.del_eol.$$:
        b     @ed_wait              ; Back to editor main


*---------------------------------------------------------------
* Delete current line
*---------------------------------------------------------------
ed_pk.action.del_line:
        ;-------------------------------------------------------
        ; Special treatment if only 1 line in file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        jne   !
        clr   @fb.column            ; Column 0
        b     @ed_pk.action.del_eol ; Delete until end of line
        ;-------------------------------------------------------
        ; Delete entry in index
        ;-------------------------------------------------------
!       bl    @fb.calc_pointer      ; Calculate position in frame buffer
        clr   @fb.row.dirty         ; Discard current line        
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to remove
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        bl    @idx.entry.delete     ; Reorganize index
        dec   @edb.lines            ; One line less in editor buffer
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Special treatment if current line was last line
        ;-------------------------------------------------------
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Was last line?
        jle   ed_pk.action.del_line.$$
        b     @ed_pk.action.up      ; One line up
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.del_line.$$:
        b     @ed_pk.action.home    ; Move cursor to home and return



*---------------------------------------------------------------
* Insert character
*
* @parm1 = high byte has character to insert
*---------------------------------------------------------------
ed_pk.action.ins_char.ws
        li    tmp0,>2000            ; White space
        mov   tmp0,@parm1
ed_pk.action.ins_char:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        ;-------------------------------------------------------
        ; Sanity check 1 - Empty line
        ;-------------------------------------------------------
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   ed_pk.action.ins_char.sanity
                                    ; Add character in overwrite mode
        ;-------------------------------------------------------
        ; Sanity check 2 - EOL
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jeq   ed_pk.action.ins_char.sanity
                                    ; Add character in overwrite mode
        ;-------------------------------------------------------
        ; Prepare for insert operation
        ;-------------------------------------------------------
ed_pk.action.skipsanity:
        mov   tmp2,tmp3             ; tmp3=line length
        s     @fb.column,tmp3
        a     tmp3,tmp0             ; tmp0=Pointer to last char in line
        mov   tmp0,tmp1
        inc   tmp1                  ; tmp1=tmp0+1
        s     @fb.column,tmp2       ; tmp2=amount of characters to move
        inc   tmp2
        ;-------------------------------------------------------
        ; Loop from end of line until current character
        ;-------------------------------------------------------
ed_pk.action.ins_char_loop:
        movb  *tmp0,*tmp1           ; Move char to the right
        dec   tmp0
        dec   tmp1
        dec   tmp2
        jne   ed_pk.action.ins_char_loop
        ;-------------------------------------------------------
        ; Set specified character on current position
        ;-------------------------------------------------------
        movb  @parm1,*tmp1
        ;-------------------------------------------------------
        ; Save variables
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        inc   @fb.row.length        ; @fb.row.length
        ;-------------------------------------------------------
        ; Add character in overwrite mode
        ;-------------------------------------------------------
ed_pk.action.ins_char.sanity
        b     @ed_pk.action.char.overwrite
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.ins_char.$$:
        b     @ed_wait              ; Back to editor main






*---------------------------------------------------------------
* Insert new line
*---------------------------------------------------------------
ed_pk.action.ins_line:
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.ins_line.insert
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Insert entry in index
        ;-------------------------------------------------------
ed_pk.action.ins_line.insert:        
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to insert

        mov   @edb.lines,@parm2     ; Last line to reorganize 
        bl    @idx.entry.insert     ; Reorganize index
        inc   @edb.lines            ; One line more in editor buffer
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.ins_line.$$:
        b     @ed_wait              ; Back to editor main






*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
ed_pk.action.enter:
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   ed_pk.action.enter.upd_counter
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Update line counter
        ;-------------------------------------------------------
ed_pk.action.enter.upd_counter:
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Last line in editor buffer?
        jne   ed_pk.action.newline  ; No, continue newline
        inc   @edb.lines            ; Total lines++
        ;-------------------------------------------------------
        ; Process newline 
        ;-------------------------------------------------------
ed_pk.action.newline:
        ;-------------------------------------------------------
        ; Scroll 1 line if cursor at bottom row of screen
        ;-------------------------------------------------------
        mov   @fb.screenrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   ed_pk.action.newline.down
        ;-------------------------------------------------------
        ; Scroll
        ;-------------------------------------------------------
        mov   @fb.screenrows,tmp0
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        jmp   ed_pk.action.newline.rest
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
ed_pk.action.newline.down:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Set VDP cursor and save variables
        ;-------------------------------------------------------
ed_pk.action.newline.rest:
        bl    @fb.get.firstnonblank
        mov   @outparm1,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
        bl    @edb.line.getlength2  ; Get length of new row length
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.newline.$$:
        b     @ed_wait              ; Back to editor main




*---------------------------------------------------------------
* Toggle insert/overwrite mode
*---------------------------------------------------------------
ed_pk.action.ins_onoff:
        inv   @edb.insmode          ; Toggle insert/overwrite mode
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------
        li    tmp0,2000
ed_pk.action.ins_onoff.loop:
        dec   tmp0
        jne   ed_pk.action.ins_onoff.loop
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.ins_onoff.$$:
        b     @task2.cur_visible    ; Update cursor shape






*---------------------------------------------------------------
* Process character
*---------------------------------------------------------------
ed_pk.action.char:
        movb  tmp1,@parm1           ; Store character for insert
        mov   @edb.insmode,tmp0     ; Insert or overwrite ?
        jeq   ed_pk.action.char.overwrite
        ;-------------------------------------------------------
        ; Insert mode
        ;-------------------------------------------------------
ed_pk.action.char.insert:
        b     @ed_pk.action.ins_char
        ;-------------------------------------------------------
        ; Overwrite mode
        ;-------------------------------------------------------
ed_pk.action.char.overwrite:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.current,tmp0      ; Get pointer
        
        movb  @parm1,*tmp0          ; Store character in editor buffer
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh

        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        ;-------------------------------------------------------
        ; Update line length in frame buffer
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
        jlt   ed_pk.action.char.$$  ; column < length line ? Skip further processing
        mov   @fb.column,@fb.row.length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
ed_pk.action.char.$$:
        b     @ed_wait              ; Back to editor main


* FILE......: edkey.fb.mov.asm
* Purpose...: Actions for moving to words in frame buffer pane.

*---------------------------------------------------------------
* Cursor beginning of word or previous word
*---------------------------------------------------------------
edkey.action.pword:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
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
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.pword.exit:
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
                                    
!       b     @edkey.keyscan.hook.debounce; Back to editor main



*---------------------------------------------------------------
* Cursor next word
*---------------------------------------------------------------
edkey.action.nword:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
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
        mov   tmp0,@fb.column       ; tmp0 also input for @xsetx
        bl    @xsetx                ; Set VDP cursor X
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.nword.exit:
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
                                    
!       b     @edkey.keyscan.hook.debounce; Back to editor main

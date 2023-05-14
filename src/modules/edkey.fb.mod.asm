* FILE......: edkey.fb.mod.asm
* Purpose...: Actions for modifier keys in frame buffer pane.

*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edkey.action.enter:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.enter.newline
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Insert a new line if insert mode is on
        ;-------------------------------------------------------
edkey.action.enter.newline:
        mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
        jeq   edkey.action.enter.upd_counter
                                    ; Overwrite mode, skip insert

        mov   @edb.autoinsert,tmp0  ; Autoinsert on?
        jeq   edkey.action.enter.upd_counter
                                    ; Autoinsert off, skip insert

        seto  @parm1                ; Insert line on following line
        
        bl    @fb.insert.line       ; Insert a new line
                                    ; \  i  @parm1 = current/following line
                                    ; /
        ;-------------------------------------------------------
        ; Update line counter
        ;-------------------------------------------------------
edkey.action.enter.upd_counter:
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        inc   tmp0
        c     tmp0,@edb.lines       ; Last line in editor buffer?
        jlt   edkey.action.newline  ; No, continue newline
        inc   @edb.lines            ; Total lines++
        ;-------------------------------------------------------
        ; Process newline
        ;-------------------------------------------------------
edkey.action.newline:
        ;-------------------------------------------------------
        ; Scroll 1 line if cursor at bottom row of screen
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   edkey.action.newline.down
        ;-------------------------------------------------------
        ; Scroll
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        jmp   edkey.action.newline.rest
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
edkey.action.newline.down:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Set VDP cursor and save variables
        ;-------------------------------------------------------
edkey.action.newline.rest:
        bl    @fb.get.nonblank      ; \ Get column of first nonblank character
                                    ; | o  @outparm1 = Matching column
                                    ; / o  @outparm2 = Char on matching column

        mov   @outparm1,tmp0
        mov   tmp0,@fb.column
        bl    @xsetx                ; Set Column=tmp0 (VDP cursor)
        
        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row

        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.newline.exit:
        b     @edkey.keyscan.hook.debounce; Back to editor main




*---------------------------------------------------------------
* Toggle insert/overwrite mode
*---------------------------------------------------------------
edkey.action.ins_onoff:
        dect  stack
        mov   r11,*stack            ; Save return address

        seto  @fb.status.dirty      ; Trigger refresh of status lines
        inv   @edb.insmode          ; Toggle insert/overwrite mode
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_onoff.exit:
        mov   *stack+,r11           ; Pop r11
        b     @edkey.keyscan.hook.debounce; Back to editor main



*---------------------------------------------------------------
* Add character (frame buffer)
*---------------------------------------------------------------
edkey.action.char:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Asserts
        ;-------------------------------------------------------
        movb  tmp1,tmp0             ; Get keycode
        srl   tmp0,8                ; MSB to LSB

        ci    tmp0,32               ; Keycode < ASCII 32 ?
        jlt   edkey.action.char.exit
                                    ; Yes, skip

        ci    tmp0,126              ; Keycode > ASCII 126 ?
        jgt   edkey.action.char.exit
                                    ; Yes, skip
        ;-------------------------------------------------------
        ; Setup
        ;-------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        clr   @parm1
        movb  tmp1,@parm1           ; Store character for insert
        mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
        jeq   edkey.action.char.overwrite
        ;-------------------------------------------------------
        ; Insert mode
        ;-------------------------------------------------------
        bl    @fb.insert.char       ; Insert character
                                    ; \ i  @parm1 = MSB character to insert
                                    ; |             LSB = 0 move cursor right
                                    ; /             LSB > 0 do not move cursor

        jmp   edkey.action.char.exit 
        ;-------------------------------------------------------
        ; Overwrite mode - Write character
        ;-------------------------------------------------------
edkey.action.char.overwrite:
        bl    @fb.replace.char      ; Replace (overwrite) character
                                    ; \ i  @parm1 = MSB character to replace
                                    ; /                                
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.char.exit:
        b     @edkey.keyscan.hook.debounce; Back to editor main

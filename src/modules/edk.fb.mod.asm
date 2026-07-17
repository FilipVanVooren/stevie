* FILE......: edk.fb.mod.asm
* Purpose...: Actions for modifier keys in frame buffer pane.

*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edk.act.enter:
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edk.act.enter.newline
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
edk.act.enter.newline:
        mov   @edb.insmode,tmp0     ; Insert mode or overwrite mode?
        jeq   edk.act.enter.upd_counter
                                    ; Overwrite mode, skip insert

        mov   @edb.autoinsert,tmp0  ; Autoinsert on?
        jeq   edk.act.enter.upd_counter
                                    ; Autoinsert off, skip insert

        seto  @parm1                ; Insert line on following line
        
        bl    @fb.insert.line       ; Insert a new line
                                    ; \  i  @parm1 = current/following line
                                    ; /
        ;-------------------------------------------------------
        ; Update line counter
        ;-------------------------------------------------------
edk.act.enter.upd_counter:
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        inc   tmp0
        c     tmp0,@edb.lines       ; Last line in editor buffer?
        jlt   edk.act.newline  ; No, continue newline
        inc   @edb.lines            ; Total lines++
        ;-------------------------------------------------------
        ; Process newline
        ;-------------------------------------------------------
edk.act.newline:
        ;-------------------------------------------------------
        ; Scroll 1 line if cursor at bottom row of screen
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        dec   tmp0
        c     @fb.row,tmp0
        jlt   edk.act.newline.down
        ;-------------------------------------------------------
        ; Scroll
        ;-------------------------------------------------------
        mov   @fb.scrrows,tmp0
        mov   @fb.topline,@parm1
        inc   @parm1
        bl    @fb.refresh
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        jmp   edk.act.newline.rest
        ;-------------------------------------------------------
        ; Move cursor down a row, there are still rows left
        ;-------------------------------------------------------
edk.act.newline.down:
        inc   @fb.row               ; Row++ in screen buffer
        bl    @down                 ; Row++ VDP cursor
        ;-------------------------------------------------------
        ; Set VDP cursor and save variables
        ;-------------------------------------------------------
edk.act.newline.rest:
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
        bl    @vdp.cursor.tat       ; Update cursor        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.newline.exit:
        b     @edkey.keyscan.hook.debounce; Back to editor main




*---------------------------------------------------------------
* Toggle insert/overwrite mode
*---------------------------------------------------------------
edk.act.ins_onoff:
        dect  stack
        mov   r11,*stack            ; Save return address

        seto  @fb.status.dirty      ; Trigger refresh of status lines
        inv   @edb.insmode          ; Toggle insert/overwrite mode
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.ins_onoff.exit:
        mov   *stack+,r11           ; Pop r11
        b     @edkey.keyscan.hook.debounce; Back to editor main

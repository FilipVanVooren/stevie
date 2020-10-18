* FILE......: edkey.fb.mod.asm
* Purpose...: Actions for modifier keys in frame buffer pane.


*---------------------------------------------------------------
* Enter
*---------------------------------------------------------------
edkey.action.enter:
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.enter.upd_counter
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Update line counter
        ;-------------------------------------------------------
edkey.action.enter.upd_counter:
        mov   @fb.topline,tmp0
        a     @fb.row,tmp0
        c     tmp0,@edb.lines       ; Last line in editor buffer?
        jne   edkey.action.newline  ; No, continue newline
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
edkey.action.newline.exit:
        b     @hook.keyscan.bounce  ; Back to editor main




*---------------------------------------------------------------
* Toggle insert/overwrite mode
*---------------------------------------------------------------
edkey.action.ins_onoff:
        inv   @edb.insmode          ; Toggle insert/overwrite mode
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------
        li    tmp0,2000
edkey.action.ins_onoff.loop:
        dec   tmp0
        jne   edkey.action.ins_onoff.loop
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_onoff.exit: 
        b     @task.vdp.cursor      ; Update cursor shape  




*---------------------------------------------------------------
* Add character (frame buffer)
*---------------------------------------------------------------
edkey.action.char:
        ;-------------------------------------------------------
        ; Sanity checks
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
        movb  tmp1,@parm1           ; Store character for insert
        mov   @edb.insmode,tmp0     ; Insert or overwrite ?
        jeq   edkey.action.char.overwrite
        ;-------------------------------------------------------
        ; Insert mode
        ;-------------------------------------------------------
edkey.action.char.insert:
        b     @edkey.action.ins_char
        ;-------------------------------------------------------
        ; Overwrite mode - Write character
        ;-------------------------------------------------------
edkey.action.char.overwrite:
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.current,tmp0      ; Get pointer
        
        movb  @parm1,*tmp0          ; Store character in editor buffer
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Last column on screen reached?
        ;-------------------------------------------------------
        mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79.
        ci    tmp1,colrow - 1       ; / Last column on screen?
        jlt   edkey.action.char.overwrite.incx
                                    ; No, increase X position

        li    tmp1,colrow           ; \
        mov   tmp1,@fb.row.length   ; / Yes, Set row length and exit.
        jmp   edkey.action.char.exit 
        ;-------------------------------------------------------
        ; Increase column
        ;-------------------------------------------------------
edkey.action.char.overwrite.incx:
        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        ;-------------------------------------------------------
        ; Update line length in frame buffer
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
                                    ; column < line length ?
        jlt   edkey.action.char.exit
                                    ; Yes, don't update row length
        mov   @fb.column,@fb.row.length
                                    ; Set row length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.char.exit:
        b     @hook.keyscan.bounce  ; Back to editor main

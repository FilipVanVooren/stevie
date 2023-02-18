* FILE......: fb.insert.line.asm
* Purpose...: Insert a new line

***************************************************************
* fb.insert.line.asm
* Insert a new line
***************************************************************
* bl @fb.insert.line
*--------------------------------------------------------------
* INPUT
* @parm1 = Insert line on current line or on following line.
*          @parm1  = 0  -> current line
*          @parm1 <> 0  -> following line
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fb.insert.line:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        clr   tmp1                  ; Offset is current line

        mov   @parm1,tmp0           ; Insert on current line or following line?
        jeq   !                     ; Current line
        inc   tmp1                  ; Offset is Following line
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
!       c     @fb.row.dirty,@w$ffff
        jne   fb.insert.line.insert

        bl    @edb.line.pack.fb     ; Pack current line in framebuffer
                                    ; \ i  @fb.top      = Address top row in FB
                                    ; | i  @fb.row      = Current row in FB
                                    ; | i  @fb.column   = Current column in FB
                                    ; / i  @fb.colsline = Columns per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Insert entry in index
        ;-------------------------------------------------------
fb.insert.line.insert:
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        mov   @fb.topline,@parm1
        a     @fb.row,@parm1        ; Line number to insert
        a     tmp1,@parm1           ; Add optional offset (for following line)
        mov   @edb.lines,@parm2     ; Last line to reorganize

        bl    @idx.entry.insert     ; Reorganize index
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg

        inc   @edb.lines            ; One line added to editor buffer
        clr   @fb.row.length        ; Current row length = 0
        ;-------------------------------------------------------
        ; Check/Adjust marker M1
        ;-------------------------------------------------------
fb.insert.line.m1:
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   fb.insert.line.m2     ; Yes, skip to M2 check

        c     @parm1,@edb.block.m1
        jgt   fb.insert.line.m2
        inc   @edb.block.m1         ; M1++
        seto  @fb.colorize          ; Set colorize flag
        ;-------------------------------------------------------
        ; Check/Adjust marker M2
        ;-------------------------------------------------------
fb.insert.line.m2:
        c     @edb.block.m2,@w$ffff ; Marker M1 unset?
        jeq   fb.insert.line.refresh
                                    ; Yes, skip to refresh frame buffer

        c     @parm1,@edb.block.m2
        jgt   fb.insert.line.refresh
        inc   @edb.block.m2         ; M2++
        seto  @fb.colorize          ; Set colorize flag
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
fb.insert.line.refresh:
        mov   @fb.topline,@parm1

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        seto  @fb.dirty             ; Trigger screen refresh
        bl    @fb.cursor.home       ; Move cursor home
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.insert.line.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

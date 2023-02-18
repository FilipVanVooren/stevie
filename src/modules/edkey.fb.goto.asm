* FILE......: edkey.fb.goto.asm
* Purpose...: Goto specified line

***************************************************************
* edkey.fb.goto.toprow
*
* Refresh frame buffer with specified top-row and row offset,
* align variables in editor buffer to match with that position.
*
* Internal method that needs to be called via jmp or branch
* instruction.
***************************************************************
* b    @edkey.fb.goto.toprow
*--------------------------------------------------------------
* INPUT
* @parm1  = Line in editor buffer to display as top row (goto)
* @parm2  = Row offset in frame buffer
*
* Register usage
* none
********|*****|*********************|**************************
edkey.fb.goto.toprow:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------        
        ; Assert on line
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; \ Goto beyond EOF ?
        c     @edb.lines,tmp0       ; / 
        jh    !                     ; No, keep on going
        mov   @edb.lines,@parm1     ; \ Goto EOF
        dec   @parm1                ; / Base 0
        ;-------------------------------------------------------        
        ; Assert on row offset in frame buffer
        ;-------------------------------------------------------       
!       c     @parm2,@fb.scrrows    ; Row offset off page ?
        jlt   edkey.fb.goto.row     ; No, use row offset
        mov   @fb.scrrows,@fb.row   ; Limit row offset
        jmp   edkey.fb.goto.line    ; Goto line
edkey.fb.goto.row:
        mov   @parm2,@fb.row        ; Set row offset
        ;-------------------------------------------------------        
        ; Goto line
        ;-------------------------------------------------------
edkey.fb.goto.line:        
        seto  @fb.status.dirty      ; Trigger refresh of status lines

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        clr   @fb.column            ; Frame buffer column 0

        mov   @fb.row,tmp0          ; \
        sla   tmp0,8                ; | Position VDP cursor
        mov   tmp0,@wyx             ; /
        
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row

        ;-------------------------------------------------------        
        ; Exit
        ;-------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Goto specified line (@parm1) in editor buffer
*---------------------------------------------------------------
edkey.action.goto:
        ;-------------------------------------------------------
        ; Crunch current row if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.goto.refresh

        dect  stack
        mov   @parm1,*stack         ; Push parm1

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        mov   *stack+,@parm1        ; Pop parm1
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.goto.refresh:
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

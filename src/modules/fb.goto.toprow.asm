* FILE......: fb.goto.toprow.asm
* Purpose...: Refresh frame buffer with specified top-row and row offset


***************************************************************
* fb.goto.toprow
* Refresh frame buffer with specified top-row and row offset,
* align variables in editor buffer to match with that position.
****************************************************************
* bl @fb.goto.toprow
*--------------------------------------------------------------
* INPUT
* @parm1  = Line in editor buffer to display as top row (goto)
* @parm2  = Row offset in frame buffer
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fb.goto.toprow:
        dect  stack
        mov   r11,*stack            ; Save return address
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
        jlt   fb.goto.toprow.offset ; No, use row offset
        mov   @fb.scrrows,@fb.row   ; Limit row offset
        jmp   fb.goto.toprow.line   ; Goto line
fb.goto.toprow.offset:
        mov   @parm2,@fb.row        ; Set row offset
        ;-------------------------------------------------------        
        ; Goto line
        ;-------------------------------------------------------
fb.goto.toprow.line:        
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
fb.goto.toprow.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

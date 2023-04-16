* FILE......: fb.insert.char.asm
* Purpose...: Insert character

***************************************************************
* fb.insert.char.asm
* Insert character
***************************************************************
* bl @fb.insert.line
*--------------------------------------------------------------
* INPUT
* @parm1 = MSB has character to insert
*          LSB = 0 move cursor right
*          LSB > 0 do not move cursor
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
********|*****|*********************|**************************
fb.insert.char:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
        ;-------------------------------------------------------
        ; Check 1 - Empty line
        ;-------------------------------------------------------
fb.insert.char.check1:
        mov   @fb.current,tmp0      ; Get pointer
        mov   @fb.row.length,tmp2   ; Get line length
        jeq   fb.insert.char.append ; Add character in append mode
        ;-------------------------------------------------------
        ; Check 2 - line-wrap if at column 80
        ;-------------------------------------------------------
fb.insert.char.check2:        
        mov   @fb.column,tmp1       ; \
        ci    tmp1,colrow-1         ; | Skip if cursor < 80th column
        jlt   fb.insert.char.check3 ; /

        mov   @fb.row.length,tmp1   ; \
        ci    tmp1,colrow           ; | Skip if line length < 80 
        jne   fb.insert.char.check3 ; /
        ;-------------------------------------------------------
        ; Wrap to new line
        ;-------------------------------------------------------
        dect  Stack
        mov   @parm1,*stack         ; Save character to add

        seto  @edb.dirty            ; Editor buffer dirty (text changed!)

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty        
        seto  @parm1                ; Insert on following line

        bl    @fb.insert.line       ; Insert empty line
                                    ; \ i  @parm1 = 0 for insert current line
                                    ; /            >0 for insert following line

        bl    @fb.cursor.down       ; Move cursor down 1 line
        clr   tmp2                  ; Clear line length

        mov   *stack+,@parm1        ; Restore character to add
        jmp   fb.insert.char.append ; Add character in append mode
        ;-------------------------------------------------------
        ; Check 3 - EOL
        ;-------------------------------------------------------
fb.insert.char.check3:        
        c     @fb.column,@fb.row.length
        jeq   fb.insert.char.append ; Add character in append mode        
        ;-------------------------------------------------------
        ; Check 4 - Insert only until line length reaches 80th column
        ;-------------------------------------------------------
fb.insert.char.check4:        
        mov   @fb.row.length,tmp1   ; \ 
        ci    tmp1,colrow           ; / 80th col reached?        
        jlt   fb.insert.char.calc   ; No, continue
        jmp   fb.insert.char.exit   ; Yes, exit
        ;-------------------------------------------------------
        ; Calculate number of characters to move
        ;-------------------------------------------------------
fb.insert.char.calc:        
        mov   tmp2,tmp3             ; tmp3=line length
        s     @fb.column,tmp3
        dec   tmp3                  ; Remove base 1 offset
        a     tmp3,tmp0             ; tmp0=Pointer to last char in line
        mov   tmp0,tmp1
        inc   tmp1                  ; tmp1=tmp0+1
        s     @fb.column,tmp2       ; tmp2=amount of characters to move
        ;-------------------------------------------------------
        ; Loop from end of line until current character
        ;-------------------------------------------------------
fb.insert.char.loop:
        movb  *tmp0,*tmp1           ; Copy character
        dec   tmp0                  ; Adjust source pointer
        dec   tmp1                  ; Adjust target pointer
        dec   tmp2                  ; Adjust counter
        jne   fb.insert.char.loop   ; All characters copied?
        ;-------------------------------------------------------
        ; Insert specified character at current position
        ;-------------------------------------------------------
        movb  @parm1,*tmp1          ; MSB has character to insert
        ;-------------------------------------------------------
        ; Save variables and exit
        ;-------------------------------------------------------
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        inc   @fb.row.length        ; @fb.row.length

        mov   @parm1,tmp0           ; Get parameter
        andi  tmp0,>00ff            ; Keep LSB
        jne   fb.insert.char.exit   ; Freeze cursor if LSB > 0

        inc   @fb.column            ; \ Adjust cursor position
        inc   @wyx                  ; / 
        jmp   fb.insert.char.exit   ; Exit
        ;-------------------------------------------------------
        ; Add character in append mode
        ;-------------------------------------------------------
fb.insert.char.append:
        bl    @fb.replace.char      ; Replace (overwrite) character
                                    ; \ i  @parm1 = MSB character to replace
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.insert.char.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

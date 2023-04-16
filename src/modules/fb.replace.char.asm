* FILE......: fb.replace.char.asm
* Purpose...: Replace (overwrite) character in line

***************************************************************
* fb.replace.char.asm
* Replace (overwrite) character in line
***************************************************************
* bl @fb.replace.char.asm
*--------------------------------------------------------------
* INPUT
* @parm1 = MSB has character to replace
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fb.replace.char:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
                                    
        mov   @fb.current,tmp0      ; Get pointer

        movb  @parm1,*tmp0          ; Store character in editor buffer
        seto  @fb.row.dirty         ; Current row needs to be crunched/packed
        seto  @fb.dirty             ; Trigger screen refresh
        ;-------------------------------------------------------
        ; Last column on screen reached?
        ;-------------------------------------------------------
        mov   @fb.column,tmp1       ; \ Columns are counted from 0 to 79
        ci    tmp1,colrow - 1       ; | Last column on screen?
        jlt   fb.replace.char.incx  ; / No, increase X position

        li    tmp1,colrow           ; \
        mov   tmp1,@fb.row.length   ; | Yes, set row length and exit.
        jmp   fb.replace.char.exit  ; /
        ;-------------------------------------------------------
        ; Increase column
        ;-------------------------------------------------------
fb.replace.char.incx:
        inc   @fb.column            ; Column++ in screen buffer
        inc   @wyx                  ; Column++ VDP cursor
        ;-------------------------------------------------------
        ; Update line length in frame buffer
        ;-------------------------------------------------------
        c     @fb.column,@fb.row.length
                                    ; column < line length ?
        jlt   fb.replace.char.exit  ; Yes, don't update row length
        mov   @fb.column,@fb.row.length
                                    ; Set row length
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.replace.char.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

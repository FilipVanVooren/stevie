* FILE......: fb.cursor.top.asm
* Purpose...: Move cursor to top of screen in editor buffer


***************************************************************
* fb.cursor.topscr
* Move cursor to top of screen in frame buffer
***************************************************************
* bl @fb.cursor.topscr
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
fb.cursor.topscr:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.topscr.refresh

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh screen
        ;-------------------------------------------------------
fb.cursor.topscr.refresh:        
        mov   @fb.topline,@parm1    ; Set to top line in frame buffer
        clr   @parm2                ; No row offset in frame buffer

        bl    @fb.goto.toprow       ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.topscr.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return       

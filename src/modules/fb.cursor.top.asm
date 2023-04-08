* FILE......: fb.cursor.top.asm
* Purpose...: Move cursor to top of file


***************************************************************
* fb.cursor.top
* Move cursor to top of file
***************************************************************
* bl @fb.cursor.top
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
fb.cursor.top:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Cursor top
        ;------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.top.refresh
        
        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
fb.cursor.top.refresh:        
        clr   @parm1                ; Set to 1st line in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        clr   @parm2                ; No row offset in frame buffer

        bl    @fb.goto.toprow       ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.top.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

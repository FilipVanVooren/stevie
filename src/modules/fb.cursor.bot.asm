* FILE......: fb.cursor.bot.asm
* Purpose...: Move cursor to bottom of file


***************************************************************
* fb.cursor.bot
* Move cursor to bottom of file
***************************************************************
* bl @fb.cursor.bot
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
fb.cursor.bot:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.cursor.bot.refresh

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
fb.cursor.bot.refresh:        
        c     @edb.lines,@fb.scrrows                                    
        jle   fb.cursor.bot.exit    ; Skip if whole editor buffer on screen

        mov   @edb.lines,tmp0
        s     @fb.scrrows,tmp0
        mov   tmp0,@parm1           ; Set to last page in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        clr   @parm2                ; No row offset in frame buffer

        bl    @fb.goto.toprow       ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.bot.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

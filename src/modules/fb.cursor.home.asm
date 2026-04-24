* FILE......: fb.cursor.home.asm
* Purpose...: Move cursor home


***************************************************************
* fb.cursor.home
* Move cursor home
***************************************************************
* bl @fb.cursor.home
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fb.cursor.home:
        .pushregs 0                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Cursor home
        ;------------------------------------------------------
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        mov   @wyx,tmp0
        andi  tmp0,>ff00            ; Reset cursor X position to 0
        mov   tmp0,@wyx             ; VDP cursor column=0
        clr   @fb.column
        
        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        seto  @fb.status.dirty      ; Trigger refresh of status lines
        bl    @vdp.cursor.tat       ; Update cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.cursor.home.exit:
        .popregs 0                  ; Pop registers and return to caller        

* FILE......: fb.utils.asm
* Purpose...: Stevie Editor - Framebuffer utilities

***************************************************************
* fb.row2line
* Calculate line in editor buffer
***************************************************************
* bl @fb.row2line
*--------------------------------------------------------------
* INPUT
* @fb.topline = Top line in frame buffer
* @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Matching line in editor buffer
*--------------------------------------------------------------
* Register usage
* tmp2,tmp3
*--------------------------------------------------------------
* Formula
* outparm1 = @fb.topline + @parm1
********|*****|*********************|**************************
fb.row2line:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Calculate line in editor buffer
        ;------------------------------------------------------
        mov   @parm1,tmp0
        a     @fb.topline,tmp0
        mov   tmp0,@outparm1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.row2line.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller




***************************************************************
* fb.calc_pointer 
* Calculate pointer address in frame buffer
***************************************************************
* bl @fb.calc_pointer
*--------------------------------------------------------------
* INPUT
* @fb.top       = Address of top row in frame buffer
* @fb.topline   = Top line in frame buffer
* @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
* @fb.column    = Current column in frame buffer
* @fb.colsline  = Columns per line in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @fb.current   = Updated pointer
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
*--------------------------------------------------------------
* Formula
* pointer = row * colsline + column + deref(@fb.top.ptr)
********|*****|*********************|**************************
fb.calc_pointer:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Calculate pointer
        ;------------------------------------------------------
        mov   @fb.row,tmp0
        mpy   @fb.colsline,tmp0     ; tmp1 = row  * colsline
        a     @fb.column,tmp1       ; tmp1 = tmp1 + column 
        a     @fb.top.ptr,tmp1      ; tmp1 = tmp1 + base
        mov   tmp1,@fb.current
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.calc_pointer.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller







***************************************************************
* fb.get.firstnonblank
* Get column of first non-blank character in specified line
***************************************************************
* bl @fb.get.firstnonblank
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Column containing first non-blank character
* @outparm2 = Character
********|*****|*********************|**************************
fb.get.firstnonblank:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Prepare for scanning
        ;------------------------------------------------------
        clr   @fb.column
        bl    @fb.calc_pointer
        bl    @edb.line.getlength2  ; Get length current line
        mov   @fb.row.length,tmp2   ; Set loop counter
        jeq   fb.get.firstnonblank.nomatch
                                    ; Exit if empty line
        mov   @fb.current,tmp0      ; Pointer to current char
        clr   tmp1
        ;------------------------------------------------------
        ; Scan line for non-blank character
        ;------------------------------------------------------
fb.get.firstnonblank.loop:
        movb  *tmp0+,tmp1           ; Get character
        jeq   fb.get.firstnonblank.nomatch 
                                    ; Exit if empty line
        ci    tmp1,>2000            ; Whitespace?
        jgt   fb.get.firstnonblank.match
        dec   tmp2                  ; Counter--
        jne   fb.get.firstnonblank.loop
        jmp   fb.get.firstnonblank.nomatch
        ;------------------------------------------------------
        ; Non-blank character found
        ;------------------------------------------------------
fb.get.firstnonblank.match:
        s     @fb.current,tmp0      ; Calculate column
        dec   tmp0
        mov   tmp0,@outparm1        ; Save column
        movb  tmp1,@outparm2        ; Save character
        jmp   fb.get.firstnonblank.exit
        ;------------------------------------------------------
        ; No non-blank character found
        ;------------------------------------------------------
fb.get.firstnonblank.nomatch:
        clr   @outparm1             ; X=0
        clr   @outparm2             ; Null
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.get.firstnonblank.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
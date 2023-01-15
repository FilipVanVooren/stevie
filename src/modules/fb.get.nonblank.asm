* FILE......: fb.get.nonblank.asm
* Purpose...: Get column of first non-blank character

***************************************************************
* fb.get.nonblank
* Get column of first non-blank character in specified line
***************************************************************
* bl @fb.get.nonblank
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Matching column
* @outparm2 = Character on matching column
********|*****|*********************|**************************
fb.get.nonblank:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Prepare for scanning
        ;------------------------------------------------------
        clr   @fb.column
        
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        bl    @edb.line.getlength2  ; Get length current line
        mov   @fb.row.length,tmp2   ; Set loop counter
        jeq   fb.get.nonblank.nomatch
                                    ; Exit if empty line
        mov   @fb.current,tmp0      ; Pointer to current char
        clr   tmp1
        ;------------------------------------------------------
        ; Scan line for non-blank character
        ;------------------------------------------------------
fb.get.nonblank.loop:
        movb  *tmp0+,tmp1           ; Get character
        jeq   fb.get.nonblank.nomatch
                                    ; Exit if empty line
        ci    tmp1,>2000            ; Whitespace?
        jgt   fb.get.nonblank.match
        dec   tmp2                  ; Counter--
        jne   fb.get.nonblank.loop
        jmp   fb.get.nonblank.nomatch
        ;------------------------------------------------------
        ; Non-blank character found
        ;------------------------------------------------------
fb.get.nonblank.match:
        s     @fb.current,tmp0      ; Calculate column
        dec   tmp0
        mov   tmp0,@outparm1        ; Save column
        movb  tmp1,@outparm2        ; Save character
        jmp   fb.get.nonblank.exit
        ;------------------------------------------------------
        ; No non-blank character found
        ;------------------------------------------------------
fb.get.nonblank.nomatch:
        clr   @outparm1             ; X=0
        clr   @outparm2             ; Null
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.get.nonblank.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: fb.get.firstnonblank.asm
* Purpose...: Get column of first non-blank character

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
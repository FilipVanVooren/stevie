* FILE......: framebuffer.asm
* Purpose...: TiVi Editor - Framebuffer module

*//////////////////////////////////////////////////////////////
*          RAM Framebuffer for handling screen output
*//////////////////////////////////////////////////////////////

***************************************************************
* fb.init 
* Initialize framebuffer
***************************************************************
*  bl   @fb.init
*--------------------------------------------------------------
*  INPUT
*  none
*--------------------------------------------------------------
*  OUTPUT 
*  none
*--------------------------------------------------------------
* Register usage
* tmp0
********@*****@*********************@**************************
fb.init
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,fb.top
        mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
        clr   @fb.topline           ; Top line in framebuffer
        clr   @fb.row               ; Current row=0
        clr   @fb.column            ; Current column=0
        li    tmp0,80 
        mov   tmp0,@fb.colsline     ; Columns per row=80
        li    tmp0,29
        mov   tmp0,@fb.screenrows   ; Physical rows on screen = 29
        seto  @fb.dirty             ; Set dirty flag (trigger screen update)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.init.$$
        b     @poprt                ; Return to caller




***************************************************************
* fb.row2line
* Calculate line in editor buffer
***************************************************************
* bl @fb.row2line
*--------------------------------------------------------------
* INPUT
* @fb.topline = Top line in frame buffer
* @parm1      = Row in frame buffer (offset 0..@fb.screenrows)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Matching line in editor buffer
*--------------------------------------------------------------
* Register usage
* tmp2,tmp3
*--------------------------------------------------------------
* Formula
* outparm1 = @fb.topline + @parm1
********@*****@*********************@**************************
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
fb.row2line$$:
        b    @poprt                 ; Return to caller




***************************************************************
* fb.calc_pointer 
* Calculate pointer address in frame buffer
***************************************************************
* bl @fb.calc_pointer
*--------------------------------------------------------------
* INPUT
* @fb.top       = Address of top row in frame buffer
* @fb.topline   = Top line in frame buffer
* @fb.row       = Current row in frame buffer (offset 0..@fb.screenrows)
* @fb.column    = Current column in frame buffer
* @fb.colsline  = Columns per line in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @fb.current   = Updated pointer
*--------------------------------------------------------------
* Register usage
* tmp2,tmp3
*--------------------------------------------------------------
* Formula
* pointer = row * colsline + column + deref(@fb.top.ptr)
********@*****@*********************@**************************
fb.calc_pointer:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Calculate pointer
        ;------------------------------------------------------
        mov   @fb.row,tmp2
        mpy   @fb.colsline,tmp2     ; tmp3 = row  * colsline
        a     @fb.column,tmp3       ; tmp3 = tmp3 + column 
        a     @fb.top.ptr,tmp3      ; tmp3 = tmp3 + base
        mov   tmp3,@fb.current
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.calc_pointer.$$
        b    @poprt                 ; Return to caller




***************************************************************
* fb.refresh
* Refresh frame buffer with editor buffer content
***************************************************************
* bl @fb.refresh
*--------------------------------------------------------------
* INPUT
* @parm1 = Line to start with (becomes @fb.topline)
*--------------------------------------------------------------
* OUTPUT
* none
********@*****@*********************@**************************
fb.refresh:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Setup starting position in index
        ;------------------------------------------------------
        mov   @parm1,@fb.topline   
        clr   @parm2                ; Target row in frame buffer
        ;------------------------------------------------------
        ; Unpack line to frame buffer
        ;------------------------------------------------------
fb.refresh.unpack_line:
        bl    @edb.line.unpack
        inc   @parm1                ; Next line in editor buffer
        inc   @parm2                ; Next row in frame buffer
        c     @parm2,@fb.screenrows ; Last row reached ?
        jlt   fb.refresh.unpack_line
        seto  @fb.dirty             ; Refresh screen
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.refresh.$$
        b    @poprt                 ; Return to caller




***************************************************************
* fb.get.firstnonblank
* Get column of first non-blank character in specified line
***************************************************************
* bl @fb.get.firstnonblank
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Column containing first non-blank character
* @outparm2 = Character
********@*****@*********************@**************************
fb.get.firstnonblank
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
fb.get.firstnonblank.match
        s     @fb.current,tmp0      ; Calculate column
        dec   tmp0
        mov   tmp0,@outparm1        ; Save column
        movb  tmp1,@outparm2        ; Save character
        jmp   fb.get.firstnonblank.$$
        ;------------------------------------------------------
        ; No non-blank character found
        ;------------------------------------------------------
fb.get.firstnonblank.nomatch
        clr   @outparm1             ; X=0
        clr   @outparm2             ; Null
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.get.firstnonblank.$$
        b    @poprt                 ; Return to caller







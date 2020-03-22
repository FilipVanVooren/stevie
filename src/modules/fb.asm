* FILE......: fb.asm
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
********|*****|*********************|**************************
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

        li    tmp0,27
        mov   tmp0,@fb.scrrows      ; Physical rows on screen = 27
        mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb

        seto  @fb.hasfocus          ; Frame buffer has focus!
        seto  @fb.dirty             ; Set dirty flag (trigger screen update)
        ;------------------------------------------------------
        ; Clear frame buffer
        ;------------------------------------------------------
        bl    @film
        data  fb.top,>00,fb.size    ; Clear it all the way
        ;------------------------------------------------------
        ; Show banner (line above frame buffer, not part of it)
        ;------------------------------------------------------
        bl    @hchar
              byte 0,0,1,80         ; Double line at top
              data EOL

        bl    @putat
              byte 0,28
              data txt.tivi         ; Banner
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.init.exit
        b     @poprt                ; Return to caller




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
* @fb.row       = Current row in frame buffer (offset 0..@fb.scrrows)
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
********|*****|*********************|**************************
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
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fb.refresh:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Update SAMS shadow registers in RAM
        ;------------------------------------------------------
        bl    @sams.copy.layout     ; Copy SAMS memory layout
              data tv.sams.2000     ; \ i  p0 = Pointer to 8 words RAM buffer
                                    ; /
        ;------------------------------------------------------        
        ; Setup starting position in index
        ;------------------------------------------------------
        mov   @parm1,@fb.topline   
        clr   @parm2                ; Target row in frame buffer
        ;------------------------------------------------------
        ; Check if already at EOF
        ;------------------------------------------------------
        c     @parm1,@edb.lines    ; EOF reached? 
        jeq   fb.refresh.erase_eob ; Yes, no need to unpack
        ;------------------------------------------------------
        ; Unpack line to frame buffer
        ;------------------------------------------------------
fb.refresh.unpack_line:
        bl    @edb.line.unpack      ; Unpack line
                                    ; \ i  parm1 = Line to unpack
                                    ; / i  parm2 = Target row in frame buffer

        inc   @parm1                ; Next line in editor buffer
        inc   @parm2                ; Next row in frame buffer
        ;------------------------------------------------------
        ; Last row in editor buffer reached ?
        ;------------------------------------------------------
        c     @parm1,@edb.lines     
        jlt   !                     ; no, do next check
                                    ; yes, erase until end of frame buffer
        ;------------------------------------------------------
        ; Erase until end of frame buffer
        ;------------------------------------------------------
fb.refresh.erase_eob:
        mov   @parm2,tmp0           ; Current row
        mov   @fb.scrrows,tmp1      ; Rows framebuffer
        s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
        mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1

        mov   tmp2,tmp2             ; Already at end of frame buffer?
        jeq   fb.refresh.exit       ; Yes, so exit
        
        mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
        a     @fb.top.ptr,tmp1      ; Add framebuffer base

        mov   tmp1,tmp0             ; tmp0 = Memory start address
        li    tmp1,32               ; Clear with space

        bl    @xfilm                ; \ Fill memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        jmp   fb.refresh.exit
        ;------------------------------------------------------
        ; Bottom row in frame buffer reached ?
        ;------------------------------------------------------
!       c     @parm2,@fb.scrrows 
        jlt   fb.refresh.unpack_line
                                    ; No, unpack next line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.refresh.exit:
        seto  @fb.dirty             ; Refresh screen
        mov   *stack+,tmp2          ; Pop tmp2
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
        b    @poprt                 ; Return to caller
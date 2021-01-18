* FILE......: fb.refresh.asm
* Purpose...: Refresh frame buffer with editor buffer content

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
        ; Setup starting position in index
        ;------------------------------------------------------
        mov   @parm1,@fb.topline   
        clr   @parm2                ; Target row in frame buffer
        ;------------------------------------------------------
        ; Check if already at EOF
        ;------------------------------------------------------
        c     @parm1,@edb.lines     ; EOF reached? 
        jeq   fb.refresh.erase_eob  ; Yes, no need to unpack
        ;------------------------------------------------------
        ; Unpack line to frame buffer
        ;------------------------------------------------------
fb.refresh.unpack_line:
        bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in frame buffer
                                    ; / o  outparm1 = Length of line

        inc   @parm1                ; Next line in editor buffer
        inc   @parm2                ; Next row in frame buffer
        ;------------------------------------------------------
        ; Last row in editor buffer reached ?
        ;------------------------------------------------------
        c     @parm1,@edb.lines     
        jgt   fb.refresh.erase_eob  ; yes, erase until end of frame buffer

        c     @parm2,@fb.scrrows 
        jlt   fb.refresh.unpack_line
                                    ; No, unpack next line
        jmp   fb.refresh.exit       ; Yes, exit without erasing
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
        clr   tmp1                  ; Clear with >00 character

        bl    @xfilm                ; \ Fill memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
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

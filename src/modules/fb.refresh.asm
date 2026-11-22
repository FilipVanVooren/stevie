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
* @fb.scroll = Optional request (>ffff): the caller scrolls exactly one
*              row and the frame buffer still holds the window that starts
*              at the previous @fb.topline. Only the newly exposed row is
*              unpacked, the other rows are shifted in place. The request
*              is always consumed. Ignored when the delta is not exactly
*              one row, when a row edit is still uncommitted, or when the
*              row length is odd.
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fb.refresh:
        .pushregs 2                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Fast path for a one-row scroll. Rebuilding every row is
        ; the price of a jump anywhere else in the file; shifting
        ; rows costs a fraction of that when only the top or the
        ; bottom line entered or left the window.
        ;------------------------------------------------------
        mov   @fb.scroll,tmp0       ; Remember the request
        clr   @fb.scroll            ; It is always consumed, also on errors
        ci    tmp0,>ffff            ; One-row scroll requested?
        jne   fb.refresh.full       ; No, rebuild every row

        c     @fb.row.dirty,@w$ffff ; Uncommitted edit on current row?
        jeq   fb.refresh.full       ; Yes, rebuild every row

        mov   @fb.colsline,tmp0     ; Row length
        andi  tmp0,1                ; The shift loops copy whole words
        jne   fb.refresh.full       ; Odd row length rebuilds every row

        mov   @parm1,tmp0           ; Requested top line
        s     @fb.topline,tmp0      ; Delta with the window in the frame buffer
        ci    tmp0,1                ; One line down?
        jeq   fb.refresh.rowup
        ci    tmp0,>ffff            ; One line up (-1)?
        jeq   fb.refresh.rowdown
        jmp   fb.refresh.full       ; Any other move rebuilds every row
        ;------------------------------------------------------
        ; Scroll 1 line down: rows move up one row in the frame
        ; buffer. The destination is below the source, so an
        ; ascending copy keeps the shifted rows intact.
        ;------------------------------------------------------
fb.refresh.rowup:
        mov   @fb.scrrows,@parm2    ; The exposed row is the last one
        dec   @parm2

        mov   @fb.scrrows,tmp0      ; \ Rows to shift, all but the new one
        dec   tmp0                  ; /
        mpy   @fb.colsline,tmp0     ; Bytes to shift (16 bit part in tmp1)

        mov   tmp1,tmp2             ; Byte count (fits 16 bits for all modes)
        ci    tmp2,0                ; Nothing to shift on a 1-row screen?
        jeq   fb.refresh.full

        mov   tmp2,tmp0             ; Words to shift
        srl   tmp0,1                ; The row length is even here
        mov   @fb.top.ptr,tmp1      ; Destination = first row
        mov   tmp1,tmp2             ; Source = second row
        a     @fb.colsline,tmp2
fb.refresh.rowup.loop:
        mov   *tmp2+,*tmp1+         ; Shift 1 word up
        dec   tmp0
        jne   fb.refresh.rowup.loop
        jmp   fb.refresh.rowload
        ;------------------------------------------------------
        ; Scroll 1 line up: rows move down one row in the frame
        ; buffer. The destination is above the source, so copy
        ; backwards to keep the shifted rows intact.
        ;------------------------------------------------------
fb.refresh.rowdown:
        clr   @parm2                ; The exposed row is the first one

        mov   @fb.scrrows,tmp0      ; \ Rows to shift, all but the new one
        dec   tmp0                  ; /
        mpy   @fb.colsline,tmp0     ; Bytes to shift (16 bit part in tmp1)

        mov   tmp1,tmp2             ; Byte count (fits 16 bits for all modes)
        ci    tmp2,0                ; Nothing to shift on a 1-row screen?
        jeq   fb.refresh.full

        mov   @fb.top.ptr,tmp0      ; Source end = first row + bytes
        a     tmp2,tmp0
        mov   @fb.top.ptr,tmp1      ; Destination end = second row + bytes
        a     @fb.colsline,tmp1
        a     tmp2,tmp1
        srl   tmp2,1                ; Words to shift, the length is even
fb.refresh.rowdown.loop:
        dect  tmp0                  ; Step back one word
        dect  tmp1
        mov   *tmp0,*tmp1
        dec   tmp2
        jne   fb.refresh.rowdown.loop
        ;------------------------------------------------------
        ; Unpack the single row that the scroll exposed. Rows that
        ; only moved keep their content. A line beyond the editor
        ; buffer unpacks as a blank row, so end-of-file needs no
        ; extra erase pass.
        ;------------------------------------------------------
fb.refresh.rowload:
        mov   @parm1,@fb.topline    ; New top line of the window
        a     @parm2,@parm1         ; Line that belongs to the exposed row
        mov   @fb.vwco,@parm3       ; Column offset

        bl    @edb.line.unpack.fb   ; Unpack 1 row
                                    ; \ i  @parm1 = Line to unpack
                                    ; | i  @parm2 = Target row in frame buffer
                                    ; | i  @parm3 = Column offset

        jmp   fb.refresh.prexit     ; Trigger a screen refresh and exit
        ;------------------------------------------------------        
        ; Setup starting position in index
        ;------------------------------------------------------
fb.refresh.full:
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
        mov   @fb.vwco,@parm3       ; Set view window column offset

        bl    @edb.line.unpack.fb   ; Unpack line from editor buffer
                                    ; \ i  parm1    = Line to unpack
                                    ; | i  parm2    = Target row in frame buffer
                                    ; | i  parm3    = Column offset
                                    ; / o  outparm1 = Length of line

        inc   @parm1                ; Next line in editor buffer
        inc   @parm2                ; Next row in frame buffer
        ;------------------------------------------------------
        ; Last row in editor buffer reached ?
        ;------------------------------------------------------
        c     @parm1,@edb.lines     ; BOT reached?
        jeq   fb.refresh.erase_eob  ; yes, erase until end of frame buffer

        c     @parm2,@fb.scrrows 
        jlt   fb.refresh.unpack_line
                                    ; No, unpack next line
        jmp   fb.refresh.prexit     ; Yes, exit without erasing
        ;------------------------------------------------------
        ; Erase until end of frame buffer
        ;------------------------------------------------------
fb.refresh.erase_eob:
        mov   @parm2,tmp0           ; Current row
        mov   @fb.scrrows,tmp1      ; Rows framebuffer
        s     tmp0,tmp1             ; tmp1 = rows framebuffer - current row
        mpy   @fb.colsline,tmp1     ; tmp2 = cols per row * tmp1

        mov   tmp2,tmp2             ; Already at end of frame buffer?
        jeq   fb.refresh.prexit     ; Yes, so exit
        
        mpy   @fb.colsline,tmp0     ; cols per row * tmp0 (Result in tmp1!)
        a     @fb.top.ptr,tmp1      ; Add framebuffer base

        mov   tmp1,tmp0             ; tmp0 = Memory start address
        clr   tmp1                  ; Clear with >00 character

        bl    @xfilm                ; \ Fill memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        ;------------------------------------------------------
        ; Prepare exit
        ;------------------------------------------------------                                    
fb.refresh.prexit:
        seto  @fb.dirty             ; Refresh screen
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.refresh.exit:
        .popregs 2                  ; Pop registers and return to caller                
        

* FILE......: edb.line.unpack.fb.asm
* Purpose...: Unpack line from editor buffer to frame buffer

***************************************************************
* edb.line.unpack.fb
* Unpack specified line to framebuffer
***************************************************************
*  bl   @edb.line.unpack.fb
*--------------------------------------------------------------
* INPUT
* @parm1 = Line to unpack in editor buffer (base 0)
* @parm2 = Target row in frame buffer
* @parm3 = Column offset (normally supplied by @fb.vwco)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of unpacked line
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf    = Saved @parm1 of edb.line.unpack.fb
* rambuf+2  = Saved @parm2 of edb.line.unpack.fb
* rambuf+4  = Saved @parm3 of edb.line.unpack.fb
* rambuf+6  = Source memory address in editor buffer
* rambuf+8  = Destination memory address in frame buffer
* rambuf+10 = Length of line
*--------------------------------------------------------------
* The row is not erased up front. The visible text is copied first
* and only the columns it did not reach are erased, which leaves
* the row byte for byte identical to a full 80 column erase while
* writing len bytes less for every unpacked row.
********|*****|*********************|**************************
edb.line.unpack.fb:
        .pushregs 4                 ; tmp4 survives the block copy and keeps
                                    ; the number of columns written to the row
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
        mov   @parm1,@rambuf       
        mov   @parm2,@rambuf+2
        mov   @parm3,@rambuf+4
        ;------------------------------------------------------
        ; Calculate offset in frame buffer
        ;------------------------------------------------------
        mov   @fb.colsline,tmp0
        mpy   @parm2,tmp0           ; Offset is in tmp1!
        mov   @fb.top.ptr,tmp2
        a     tmp2,tmp1             ; Add base to offset
        mov   tmp1,@rambuf+8        ; Destination row in frame buffer
        ;------------------------------------------------------
        ; Return empty row if requested line beyond editor buffer
        ;------------------------------------------------------
        c     @parm1,@edb.lines     ; Requested line at BOT?
        jlt   !                     ; No, continue processing
        
        clr   @rambuf+10            ; Set line length = 0
        jmp   edb.line.unpack.fb.prepare
        ;------------------------------------------------------
        ; Get pointer to line & page-in editor buffer page
        ;------------------------------------------------------
!       mov   @parm1,tmp0
        bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page
        ;------------------------------------------------------
        ; Handle empty line
        ;------------------------------------------------------        
        mov   @outparm1,tmp0        ; Get pointer to line
        jne   edb.line.unpack.fb.getlen
                                    ; Only continue if pointer is set

        clr   @rambuf+10            ; Set length=0
        jmp   edb.line.unpack.fb.prepare
        ;------------------------------------------------------
        ; Get line length
        ;------------------------------------------------------ 
edb.line.unpack.fb.getlen:                                        
        mov   *tmp0+,@rambuf+10     ; Get line length
        mov   tmp0,@rambuf+6        ; Source memory address for block copy
        ;------------------------------------------------------
        ; Prepare for unpacking data
        ;------------------------------------------------------
edb.line.unpack.fb.prepare: 
        mov   @rambuf+10,tmp2       ; Get Line length
        mov   tmp2,@outparm1        ; Store in output parameter        
        jeq   edb.line.unpack.fb.blank
                                    ; Nothing to copy if length = 0

        c     @rambuf+4,tmp2        ; Column offset (@fb.vwco) > line length
        jhe   edb.line.unpack.fb.blank
                                    ; Yes, the row is scrolled out of view

        s     @rambuf+4,tmp2        ; Subtract @fb.vwco from line length
        ;------------------------------------------------------
        ; Assert on line length
        ;------------------------------------------------------
        jle   edb.line.unpack.fb.blank
                                    ; Erase the row if nothing is visible

        ci    tmp2,80               ; Check line length
        jle   edb.line.unpack.fb.copy
        li    tmp2,80               ; Only process first 80 characters
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
edb.line.unpack.fb.copy:        
        mov   tmp2,tmp4             ; Columns the copy writes to the row

        mov   @rambuf+8,tmp1        ; Pointer to row in frame buffer
        mov   @rambuf+6,tmp0        ; Pointer to line in editor buffer
        a     @rambuf+4,tmp0        ; Add column offset (@fb.vwco)

        bl    @xpym2m               ; Copy line to frame buffer
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Target address 
                                    ; / i  tmp2 = Bytes to copy
        jmp   edb.line.unpack.fb.erase
        ;------------------------------------------------------
        ; No text visible on this row, erase all of it
        ;------------------------------------------------------
edb.line.unpack.fb.blank:
        clr   tmp4                  ; No columns copied
        ;------------------------------------------------------
        ; Erase the columns that the copy did not cover, so tmp4 is
        ; at most 80 here (clamped above). A completely filled row
        ; skips the fill because xfilm asserts on a repeat count of
        ; zero.
        ;------------------------------------------------------
edb.line.unpack.fb.erase:
        li    tmp2,80
        s     tmp4,tmp2             ; Columns left in the row
        ci    tmp2,0                ; Row already full?
        jeq   edb.line.unpack.fb.exit
                                    ; xfilm asserts on a zero repeat count

        mov   @rambuf+8,tmp0        ; \ Start erasing behind the text
        a     tmp4,tmp0             ; /
        clr   tmp1                  ; Fill with >00

        bl    @xfilm                ; Fill CPU memory
                                    ; \ i  tmp0 = Target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.unpack.fb.exit:
        .popregs 4                  ; Pop registers and return to caller

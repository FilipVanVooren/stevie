* FILE......: editorbuffer.asm
* Purpose...: TiVi Editor - Editor Buffer module

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Editor Buffer implementation
*//////////////////////////////////////////////////////////////

***************************************************************
* edb.init
* Initialize Editor buffer
***************************************************************
* bl @edb.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
***************************************************************
edb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,edb.top
        mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
        mov   tmp0,@edb.next_free.ptr
                                    ; Set pointer to next free line in editor buffer
        seto  @edb.insmode          ; Turn on insert mode for this editor buffer
        clr   @edb.lines            ; Lines=0

edb.init.exit:        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @poprt                ; Return to caller



***************************************************************
* edb.line.pack
* Pack current line in framebuffer
***************************************************************
*  bl   @edb.line.pack
*--------------------------------------------------------------
* INPUT
* @fb.top       = Address of top row in frame buffer
* @fb.row       = Current row in frame buffer
* @fb.column    = Current column in frame buffer
* @fb.colsline  = Columns per line in frame buffer
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf   = Saved @fb.column
* rambuf+2 = Saved beginning of row
* rambuf+4 = Saved length of row
********@*****@*********************@**************************
edb.line.pack:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Get values
        ;------------------------------------------------------
        mov   @fb.column,@rambuf    ; Save @fb.column
        clr   @fb.column
        bl    @fb.calc_pointer      ; Beginning of row
        ;------------------------------------------------------
        ; Prepare scan
        ;------------------------------------------------------
        clr   tmp0                  ; Counter 
        mov   @fb.current,tmp1      ; Get position
        mov   tmp1,@rambuf+2        ; Save beginning of row

        ;------------------------------------------------------
        ; Scan line for >00 byte termination
        ;------------------------------------------------------
edb.line.pack.scan:
        movb  *tmp1+,tmp2           ; Get char
        srl   tmp2,8                ; Right justify
        jeq   edb.line.pack.checklength
                                    ; Stop scan if >00 found
        inc   tmp0                  ; Increase string length
        jmp   edb.line.pack.scan    ; Next character

        ;------------------------------------------------------
        ; Handle line placement depending on length
        ;------------------------------------------------------
edb.line.pack.checklength:
        mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
        a     @fb.row,@parm1        ; /

        mov   tmp0,@rambuf+4        ; Save length of line

        ;------------------------------------------------------
        ; 1. Update index
        ;------------------------------------------------------
edb.line.pack.idx.normal:
        mov   @edb.next_free.ptr,@parm2 
                                    ; Block where line will reside

        clr   @parm3                ; SAMS bank 
        bl    @idx.entry.update     ; parm1 (line number) = fb.topline + fb.row
                                    ; parm2 (pointer)     = pointer to line in editor buffer
                                    ; parm3 (SAMS bank)   = 0

        ;------------------------------------------------------
        ; 2. Set line prefix in editor buffer
        ;------------------------------------------------------
        mov   @rambuf+2,tmp0        ; Source for memory copy
        mov   @edb.next_free.ptr,tmp1 
                                    ; Address of line in editor buffer

        inct  @edb.next_free.ptr    ; Adjust pointer

        mov   @rambuf+4,tmp2        ; Get line length
        mov   tmp2,*tmp1+           ; Set line length as line prefix
        jeq   edb.line.pack.exit    ; Nothing to copy if empty line

        ;------------------------------------------------------
        ; 3. Copy line from framebuffer to editor buffer
        ;------------------------------------------------------
        bl    @xpym2m               ; Copy memory block
                                    ;   tmp0 = source
                                    ;   tmp1 = destination
                                    ;   tmp2 = bytes to copy
        a     @rambuf+4,@edb.next_free.ptr
                                    ; Update pointer to next free block 

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.pack.exit:
        mov   @rambuf,@fb.column    ; Retrieve @fb.column
        b     @poprt                ; Return to caller


***************************************************************
* edb.line.unpack
* Unpack specified line to framebuffer
***************************************************************
*  bl   @edb.line.unpack
*--------------------------------------------------------------
* INPUT
* @parm1 = Line to unpack from editor buffer
* @parm2 = Target row in frame buffer
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf   = Saved @parm1 of edb.line.unpack
* rambuf+2 = Saved @parm2 of edb.line.unpack
* rambuf+4 = Source memory address in editor buffer
* rambuf+6 = Destination memory address in frame buffer
* rambuf+8 = Length of unpacked line
********@*****@*********************@**************************
edb.line.unpack:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
        mov   @parm1,@rambuf       
        mov   @parm2,@rambuf+2  
        ;------------------------------------------------------
        ; Calculate offset in frame buffer
        ;------------------------------------------------------
        mov   @fb.colsline,tmp0
        mpy   @parm2,tmp0           ; Offset is in tmp1!
        mov   @fb.top.ptr,tmp2
        a     tmp2,tmp1             ; Add base to offset
        mov   tmp1,@rambuf+6        ; Destination row in frame buffer

        ;------------------------------------------------------
        ; Index. Calculate address of entry and get pointer
        ;------------------------------------------------------
        bl    @idx.pointer.get      ; Get pointer to editor buffer entry
                                    ; parm1 = Line number

        inct  @outparm1             ; Skip line prefix
        mov   @outparm1,@rambuf+4   ; Source memory address for block copy

        ;------------------------------------------------------        
        ; Get length of line to unpack
        ;------------------------------------------------------
        bl    @edb.line.getlength   ; Get length of line
                                    ; parm1 = Line number

        mov   @outparm1,@rambuf+8   ; Bytes to copy                         

        ;------------------------------------------------------
        ; Erase chars from last column until column 80
        ;------------------------------------------------------
edb.line.unpack.clear: 
        mov   @rambuf+6,tmp0        ; Start of row in frame buffer
        a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer

        szc   @wbit1,tmp0           ; (1) Make address even (faster fill MOV)
        clr   tmp1                  ; Fill with >00
        mov   @fb.colsline,tmp2
        s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
        inc   tmp2                  ; Compensate due to (1) 

        bl    @xfilm                ; tmp0 = Target address
                                    ; tmp1 = Byte to fill
                                    ; tmp2 = Repeat count

        ;------------------------------------------------------
        ; Copy line from editor buffer to frame buffer
        ;------------------------------------------------------
edb.line.unpack.copy:
        mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
                                    ; or line content itself if line length <= 2.

        mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
        mov   @rambuf+8,tmp2        ; Bytes to copy 
        jeq   edb.line.unpack.exit  ; Exit if length = 0

        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
        bl    @xpym2m               ; Copy line to frame buffer
                                    ;   tmp0 = Source address
                                    ;   tmp1 = Target address 
                                    ;   tmp2 = Bytes to copy
        jmp   edb.line.unpack.exit

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.unpack.exit:
        b     @poprt                ; Return to caller




***************************************************************
* edb.line.getlength
* Get length of specified line
***************************************************************
*  bl   @edb.line.getlength
*--------------------------------------------------------------
* INPUT
* @parm1 = Line number
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of line
* @outparm2 = SAMS bank (>0 - >a)
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********@*****@*********************@**************************
edb.line.getlength:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Get length
        ;------------------------------------------------------
        bl    @idx.pointer.get

        mov   @outparm1,tmp0
        mov   *tmp0,tmp1            ; Get line prefix

        andi  tmp1,>00ff            ; Get rid of MSB
        mov   tmp1,@outparm1        ; Save line length
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.getlength.exit:
        b     @poprt                ; Return to caller




***************************************************************
* edb.line.getlength2
* Get length of current row (as seen from editor buffer side)
***************************************************************
*  bl   @edb.line.getlength2
*--------------------------------------------------------------
* INPUT
* @fb.row = Row in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @fb.row.length = Length of row
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********@*****@*********************@**************************
edb.line.getlength2:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Get length
        ;------------------------------------------------------
        mov   @fb.column,@rambuf    ; Save @fb.column
        mov   @fb.topline,tmp0      ; Get top line in frame buffer
        a     @fb.row,tmp0          ; Get current row in frame buffer
        sla   tmp0,2                ; Line number * 4
        mov   @idx.top+2(tmp0),tmp1 ; Get index entry line length
        andi  tmp1,>00ff            ; Get rid of SAMS page
        mov   tmp1,@fb.row.length   ; Save row length
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.getlength2.exit:
        b     @poprt                ; Return to caller


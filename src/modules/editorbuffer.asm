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
        li    tmp0,edb.top+2        ; Skip offset 0 so that it can't be confused
                                    ; with null pointer (has offset 0)

        mov   tmp0,@edb.top.ptr     ; Set pointer to top of editor buffer
        mov   tmp0,@edb.next_free.ptr
                                    ; Set pointer to next free line in editor buffer

        seto  @edb.insmode          ; Turn on insert mode for this editor buffer
        clr   @edb.lines            ; Lines=0
        clr   @edb.rle              ; RLE compression off


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
********|*****|*********************|**************************
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
        jeq   edb.line.pack.prepare ; Stop scan if >00 found
        inc   tmp0                  ; Increase string length
        jmp   edb.line.pack.scan    ; Next character

        ;------------------------------------------------------
        ; Prepare for storing line
        ;------------------------------------------------------
edb.line.pack.prepare:
        mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
        a     @fb.row,@parm1        ; /

        mov   tmp0,@rambuf+4        ; Save length of line

        ;------------------------------------------------------
        ; 1. Update index
        ;------------------------------------------------------
edb.line.pack.update_index:
        mov   @edb.next_free.ptr,tmp0
        mov   tmp0,@parm2           ; Block where line will reside

        bl    @xsams.page.get       ; Get SAMS page
                                    ; \ i  tmp0  = Memory address
                                    ; | o  waux1 = SAMS page number
                                    ; / o  waux2 = Address of SAMS register

        mov   @waux1,@parm3         ; Save SAMS page number
                                
        bl    @idx.entry.update     ; Update index
                                    ; \ i  parm1 = Line number in editor buffer
                                    ; | i  parm2 = pointer to line in editor buffer
                                    ; / i  parm3 = SAMS page

        ;------------------------------------------------------
        ; 2. Switch to required SAMS page
        ;------------------------------------------------------
        ;mov   @edb.sams.page,tmp0   ; Current SAMS page
        ;mov   @edb.next_free.ptr,tmp1
                                    ; Pointer to line in editor buffer
  ;     bl    @xsams.page           ; Switch to SAMS page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        ;------------------------------------------------------
        ; 3. Set line prefix in editor buffer
        ;------------------------------------------------------
        mov   @rambuf+2,tmp0        ; Source for memory copy
        mov   @edb.next_free.ptr,tmp1 
                                    ; Address of line in editor buffer

        inct  @edb.next_free.ptr    ; Adjust pointer

        mov   @rambuf+4,tmp2        ; Get line length
        inc   tmp1                  ; Skip MSB for now (compressed length)
        swpb  tmp2
        movb  tmp2,*tmp1+           ; Set line length as line prefix
        swpb  tmp2
        jeq   edb.line.pack.exit    ; Nothing to copy if empty line

        ;------------------------------------------------------
        ; 4. Copy line from framebuffer to editor buffer
        ;------------------------------------------------------
edb.line.pack.copyline:        
        ci    tmp2,2
        jne   edb.line.pack.copyline.checkbyte
        movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
        movb  *tmp0+,*tmp1+         ; / uneven address
        jmp   !
edb.line.pack.copyline.checkbyte:
        ci    tmp2,1
        jne   edb.line.pack.copyline.block
        movb  *tmp0,*tmp1           ; Copy single byte
        jmp   !
edb.line.pack.copyline.block:
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy

!       a     @rambuf+4,@edb.next_free.ptr
                                    ; Update pointer to next free line

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
* tmp0,tmp1,tmp2,tmp3,tmp4
*--------------------------------------------------------------
* Memory usage
* rambuf    = Saved @parm1 of edb.line.unpack
* rambuf+2  = Saved @parm2 of edb.line.unpack
* rambuf+4  = Source memory address in editor buffer
* rambuf+6  = Destination memory address in frame buffer
* rambuf+8  = Length of RLE (decompressed) line
* rambuf+10 = Length of RLE compressed line
********|*****|*********************|**************************
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
        ; Get pointer to line & page-in editor buffer page
        ;------------------------------------------------------
        mov   @parm1,tmp0
        bl    @xmem.edb.sams.pagein ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page

        inct  @outparm1             ; Skip line prefix
        mov   @outparm1,@rambuf+4   ; Source memory address for block copy
        ;------------------------------------------------------        
        ; Get length of line to unpack
        ;------------------------------------------------------
        bl    @edb.line.getlength   ; Get length of line
                                    ; \ i  parm1    = Line number
                                    ; | o  outparm1 = Line length (uncompressed)
                                    ; | o  outparm2 = Line length (compressed)
                                    ; / o  outparm3 = SAMS page

        mov   @outparm2,@rambuf+10  ; Save length of RLE compressed line
        mov   @outparm1,@rambuf+8   ; Save length of RLE (decompressed) line
        jeq   edb.line.unpack.clear ; Skip "split line" check if empty line anyway                       
        ;------------------------------------------------------
        ; Handle possible "line split" between 2 consecutive pages
        ;------------------------------------------------------
        mov     @rambuf+4,tmp0          ; Pointer to line
        mov     tmp0,tmp1               ; Pointer to line
        a       @rambuf+8,tmp1          ; Add length of line

        andi    tmp0,>f000              ; Only keep high nibble
        andi    tmp1,>f000              ; Only keep high nibble
        c       tmp0,tmp1               ; Same segment?
        jeq     edb.line.unpack.clear   ; Yes, so skip

        mov     @outparm3,tmp0          ; Get SAMS page
        inc     tmp0                    ; Next sams page

        bl      @xsams.page.set         ; \ Set SAMS memory page
                                        ; | i  tmp0 = SAMS page number
                                        ; / i  tmp1 = Memory Address

        ;------------------------------------------------------
        ; Erase chars from last column until column 80
        ;------------------------------------------------------
edb.line.unpack.clear: 
        mov   @rambuf+6,tmp0        ; Start of row in frame buffer
        a     @rambuf+8,tmp0        ; Skip until end of row in frame buffer

        clr   tmp1                  ; Fill with >00
        mov   @fb.colsline,tmp2
        s     @rambuf+8,tmp2        ; Calculate number of bytes to clear
        inc   tmp2

        bl    @xfilm                ; Fill CPU memory
                                    ; \ i  tmp0 = Target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Repeat count
        ;------------------------------------------------------
        ; Prepare for unpacking data
        ;------------------------------------------------------
edb.line.unpack.prepare: 
        mov   @rambuf+8,tmp2        ; Line length
        jeq   edb.line.unpack.exit  ; Exit if length = 0
        mov   @rambuf+4,tmp0        ; Pointer to line in editor buffer
        mov   @rambuf+6,tmp1        ; Pointer to row in frame buffer
        ;------------------------------------------------------
        ; Check before copy
        ;------------------------------------------------------
edb.line.unpack.copy.uncompressed:     
        ci    tmp2,80               ; Check line length;
        jle   !
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
!       bl    @xpym2m               ; Copy line to frame buffer
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Target address 
                                    ; / i  tmp2 = Bytes to copy
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
* @outparm1 = Length of line (uncompressed)
* @outparm2 = Length of line (compressed)
* @outparm3 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
edb.line.getlength:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @outparm1             ; Reset uncompressed length
        clr   @outparm2             ; Reset compressed length
        clr   @outparm3             ; Reset SAMS bank
        ;------------------------------------------------------
        ; Get length
        ;------------------------------------------------------
        bl    @idx.pointer.get      ; Get pointer to line
                                    ; \ i  parm1    = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page

        mov   @outparm1,tmp0        ; Is pointer set?
        jeq   edb.line.getlength.exit
                                    ; Exit early if NULL pointer
        mov   @outparm2,@outparm3   ; Save SAMS page
        ;------------------------------------------------------
        ; Process line prefix
        ;------------------------------------------------------
        clr   tmp1
        movb  *tmp0+,tmp1           ; Get compressed length
        swpb  tmp1
        mov   tmp1,@outparm2        ; Save length

        clr   tmp1
        movb  *tmp0+,tmp1           ; Get uncompressed length
        swpb  tmp1
        mov   tmp1,@outparm1        ; Save length
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
* tmp0
********|*****|*********************|**************************
edb.line.getlength2:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Calculate line in editor buffer
        ;------------------------------------------------------
        mov   @fb.topline,tmp0      ; Get top line in frame buffer
        a     @fb.row,tmp0          ; Get current row in frame buffer        
        ;------------------------------------------------------
        ; Get length
        ;------------------------------------------------------
        mov   tmp0,@parm1           
        bl    @edb.line.getlength
        mov   @outparm1,@fb.row.length
                                    ; Save row length
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.getlength2.exit:
        b     @poprt                ; Return to caller


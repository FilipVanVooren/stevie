* FILE......: edb.line.unpack.asm
* Purpose...: Stevie Editor - Editor Buffer unpack line

***************************************************************
* edb.line.unpack
* Unpack specified line to framebuffer
***************************************************************
*  bl   @edb.line.unpack
*--------------------------------------------------------------
* INPUT
* @parm1 = Line to unpack in editor buffer
* @parm2 = Target row in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of unpacked line
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf    = Saved @parm1 of edb.line.unpack
* rambuf+2  = Saved @parm2 of edb.line.unpack
* rambuf+4  = Source memory address in editor buffer
* rambuf+6  = Destination memory address in frame buffer
* rambuf+8  = Length of line
********|*****|*********************|**************************
edb.line.unpack:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        c     @parm1,@edb.lines     ; Beyond editor buffer ?
        jle   !
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
        ;------------------------------------------------------
        ; Save parameters
        ;------------------------------------------------------
!       mov   @parm1,@rambuf       
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
        bl    @xmem.edb.sams.mappage
                                    ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page
        ;------------------------------------------------------
        ; Handle empty line
        ;------------------------------------------------------        
        mov   @outparm1,tmp0        ; Get pointer to line
        jne   edb.line.unpack.getlen
                                    ; Continue if pointer is set

        clr   @rambuf+8             ; Set length=0
        jmp   edb.line.unpack.clear
        ;------------------------------------------------------
        ; Get line length
        ;------------------------------------------------------ 
edb.line.unpack.getlen:                                        
        mov   *tmp0+,tmp1           ; Get line length
        mov   tmp0,@rambuf+4        ; Source memory address for block copy
        mov   tmp1,@rambuf+8        ; Save line length        
        ;------------------------------------------------------
        ; Sanity check on line length
        ;------------------------------------------------------        
        ci    tmp1,80               ; \ Continue if length <= 80
        jle   edb.line.unpack.clear ; / 
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
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
        ; Sanity check on line length
        ;------------------------------------------------------
edb.line.unpack.copy:     
        ci    tmp2,80               ; Check line length
        jle   !
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------        
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
!       mov   tmp2,@outparm1        ; Length of unpacked line

        bl    @xpym2m               ; Copy line to frame buffer
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Target address 
                                    ; / i  tmp2 = Bytes to copy
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.unpack.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

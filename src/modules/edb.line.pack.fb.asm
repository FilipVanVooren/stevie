* FILE......: edb.line.pack.fb.asm
* Purpose...: Pack current line in framebuffer to editor buffer

***************************************************************
* edb.line.pack.fb
* Pack current line in framebuffer
***************************************************************
*  bl   @edb.line.pack.fb
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
edb.line.pack.fb:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
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
        clr   tmp3                  ; Counter for whitespace
        mov   @fb.current,tmp1      ; Get position
        mov   tmp1,@rambuf+2        ; Save beginning of row
        ;------------------------------------------------------
        ; Scan line for >00 byte termination
        ;------------------------------------------------------
edb.line.pack.fb.scan:
        movb  *tmp1+,tmp2           ; Get char
        srl   tmp2,8                ; Right justify
        jeq   edb.line.pack.fb.check_setpage
                                    ; Stop scan if >00 found
        inc   tmp0                  ; Increase string length
        ;------------------------------------------------------
        ; Check for trailing whitespace
        ;------------------------------------------------------
        ci    tmp2,32               ; Was it a space character?
        jeq   edb.line.pack.fb.check80
        mov   tmp0,tmp3
        ;------------------------------------------------------
        ; Not more than 80 characters
        ;------------------------------------------------------
edb.line.pack.fb.check80:
        ci    tmp0,colrow
        jeq   edb.line.pack.fb.check_setpage
                                    ; Stop scan if 80 characters processed
        jmp   edb.line.pack.fb.scan ; Next character
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------
edb.line.pack.fb.crash:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Check if highest SAMS page needs to be increased
        ;------------------------------------------------------
edb.line.pack.fb.check_setpage:
        c     tmp3,tmp0             ; Trailing whitespace in line?
        jlt   edb.line.pack.fb.rtrim
        mov   tmp0,@rambuf+4        ; Save full length of line
        jmp   !
edb.line.pack.fb.rtrim:
        ;------------------------------------------------------
        ; Remove trailing blanks from line
        ;------------------------------------------------------
        mov   tmp3,@rambuf+4        ; Save line length without trailing blanks

        clr   tmp1                  ; tmp1 = Character to fill (>00)

        mov   tmp0,tmp2             ; \
        s     tmp3,tmp2             ; | tmp2 = Repeat count
        inc   tmp2                  ; /

        mov   tmp3,tmp0             ; \
        a     @rambuf+2,tmp0        ; / tmp0 = Start address in CPU memory

edb.line.pack.fb.rtrim.loop:
        movb  tmp1,*tmp0+
        dec   tmp2
        jgt   edb.line.pack.fb.rtrim.loop
        ;------------------------------------------------------
        ; Check and increase highest SAMS page
        ;------------------------------------------------------
!       bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
                                    ; \ i  @edb.next_free.ptr = Pointer to next
                                    ; /                         free line
        ;------------------------------------------------------
        ; Step 2: Prepare for storing line
        ;------------------------------------------------------
edb.line.pack.fb.prepare:
        mov   @fb.topline,@parm1    ; \ parm1 = fb.topline + fb.row
        a     @fb.row,@parm1        ; /
        ;------------------------------------------------------
        ; 2a. Update index
        ;------------------------------------------------------
edb.line.pack.fb.update_index:
        mov   @edb.next_free.ptr,@parm2
                                    ; Pointer to new line
        mov   @edb.sams.hipage,@parm3
                                    ; SAMS page to use

        bl    @idx.entry.update     ; Update index
                                    ; \ i  parm1 = Line number in editor buffer
                                    ; | i  parm2 = pointer to line in
                                    ; |            editor buffer
                                    ; / i  parm3 = SAMS page
        ;------------------------------------------------------
        ; 3. Set line prefix in editor buffer
        ;------------------------------------------------------
        mov   @rambuf+2,tmp0        ; Source for memory copy
        mov   @edb.next_free.ptr,tmp1
                                    ; Address of line in editor buffer

        inct  @edb.next_free.ptr    ; Adjust pointer

        mov   @rambuf+4,tmp2        ; Get line length
        mov   tmp2,*tmp1+           ; Set line length as line prefix
        jeq   edb.line.pack.fb.prepexit
                                    ; Nothing to copy if empty line
        ;------------------------------------------------------
        ; 4. Copy line from framebuffer to editor buffer
        ;------------------------------------------------------
edb.line.pack.fb.copyline:
        ci    tmp2,2
        jne   edb.line.pack.fb.copyline.checkbyte
        movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
        movb  *tmp0+,*tmp1+         ; / uneven address
        jmp   edb.line.pack.fb.copyline.align16

edb.line.pack.fb.copyline.checkbyte:
        ci    tmp2,1
        jne   edb.line.pack.fb.copyline.block
        movb  *tmp0,*tmp1           ; Copy single byte
        jmp   edb.line.pack.fb.copyline.align16

edb.line.pack.fb.copyline.block:
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; 5: Align pointer to multiple of 16 memory address
        ;------------------------------------------------------
edb.line.pack.fb.copyline.align16:
        a     @rambuf+4,@edb.next_free.ptr
                                       ; Add length of line

        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; 6: Restore SAMS page and prepare for exit
        ;------------------------------------------------------
edb.line.pack.fb.prepexit:
        mov   @rambuf,@fb.column    ; Retrieve @fb.column

        c     @edb.sams.hipage,@edb.sams.page
        jeq   edb.line.pack.fb.exit ; Exit early if SAMS page already mapped

        mov   @edb.sams.page,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.pack.fb.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
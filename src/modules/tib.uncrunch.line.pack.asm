* FILE......: tib.uncrunch.line.pack
* Purpose...: Pack uncrunched line to editor buffer

***************************************************************
* tib.uncrunch.line.pack
* Pack uncrunched statement line to editor buffer
***************************************************************
*  bl   @tib.uncrunch.line.pack
*--------------------------------------------------------------
* INPUT
* @fb.uncrunch  = Pointer to uncrunch area
* @parm1        = Line in editor buffer
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
tib.uncrunch.line.pack:
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
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        ;------------------------------------------------------
        ; Prepare scan
        ;------------------------------------------------------
        clr   tmp0                  ; Counter
        li    tmp1,fb.uncrunch.area+1
                                    ; Get pointer to uncrunch area
        mov   @parm1,tmp3           ; Editor buffer line
        ;------------------------------------------------------
        ; 1. Scan line for >00 byte termination
        ;------------------------------------------------------
tib.uncrunch.line.pack.scan:
        movb  *tmp1+,tmp2           ; Get char
        srl   tmp2,8                ; Right justify
        jeq   tib.uncrunch.line.pack.check_setpage
                                    ; Stop scan if >00 found
        inc   tmp0                  ; Increase string length

        jmp   tib.uncrunch.line.pack.scan
                                    ; Next character
        ;------------------------------------------------------
        ; Check if highest SAMS page needs to be increased
        ;------------------------------------------------------
tib.uncrunch.line.pack.check_setpage:
        mov   tmp0,tmp4             ; Save full length of line

        bl    @edb.hipage.alloc     ; Check and increase highest SAMS page
                                    ; \ i  @edb.next_free.ptr = Pointer to next
                                    ; /    free line
        ;------------------------------------------------------
        ; 2. Update index
        ;------------------------------------------------------
        mov   tmp3,@parm1           ; Set editor buffer line
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
        li    tmp0,fb.uncrunch.area+1
                                    ; Source for memory copy
        mov   @edb.next_free.ptr,tmp1
                                    ; Address of line in editor buffer

        inct  @edb.next_free.ptr    ; Adjust pointer

        mov   tmp4,tmp2             ; Get line length
        mov   tmp2,*tmp1+           ; Set saved line length as line prefix
        ;------------------------------------------------------
        ; 4. Copy line from uncrunch area to editor buffer
        ;------------------------------------------------------
tib.uncrunch.line.pack.copyline:
        ci    tmp2,2
        jne   tib.uncrunch.line.pack.copyline.checkbyte
        movb  *tmp0+,*tmp1+         ; \ Copy single word on possible
        movb  *tmp0+,*tmp1+         ; / uneven address
        jmp   tib.uncrunch.line.pack.copyline.align16

tib.uncrunch.line.pack.copyline.checkbyte:
        ci    tmp2,1
        jne   tib.uncrunch.line.pack.copyline.block
        movb  *tmp0,*tmp1           ; Copy single byte
        jmp   tib.uncrunch.line.pack.copyline.align16

tib.uncrunch.line.pack.copyline.block:
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; 5. Align pointer to multiple of 16 memory address
        ;------------------------------------------------------
tib.uncrunch.line.pack.copyline.align16:
        a     tmp4,@edb.next_free.ptr  ; Add length of line

        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; 6. Restore SAMS page and prepare for exit
        ;------------------------------------------------------
tib.uncrunch.line.pack.prepexit:
        c     @edb.sams.hipage,@edb.sams.page
        jeq   tib.uncrunch.line.pack.exit
                                       ; Exit early if SAMS page already mapped

        mov   @edb.sams.page,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.line.pack.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
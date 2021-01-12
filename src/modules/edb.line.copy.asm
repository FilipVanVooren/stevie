* FILE......: edb.line.copy.asm
* Purpose...: Copy line in editor buffer

***************************************************************
* edb.line.copy
* Copy line in editor buffer
***************************************************************
*  bl   @edb.line.copy
*--------------------------------------------------------------
* INPUT
* @parm1 = Source line number in editor buffer
* @parm2 = Target line number in editor buffer
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Memory usage
* rambuf    = Length of source line
* rambuf+2  = line number of target line
* rambuf+4  = Pointer to source line in editor buffer
* rambuf+6  = Pointer to target line in editor buffer
*--------------------------------------------------------------
* Remarks
* @parm1 and @parm2 must be provided in base 1, but internally
* we work with base 0!
********|*****|*********************|**************************
edb.line.copy:
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
        c     @parm1,@edb.lines     ; Source line beyond editor buffer ?
        jle   !
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
!       mov   @parm2,tmp0           ; Get target line number
        dec   tmp0                  ; Base 0
        mov   tmp0,@rambuf+2        ; Save target line number        
        clr   @rambuf               ; Set source line length=0                
        clr   @rambuf+4             ; Null-pointer source line
        clr   @rambuf+6             ; Null-pointer target line
        ;------------------------------------------------------
        ; Get pointer to source line & page-in editor buffer SAMS page
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get source line number
        dec   tmp0                  ; Base 0

        bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page
        ;------------------------------------------------------
        ; Handle empty source line
        ;------------------------------------------------------        
        mov   @outparm1,tmp0        ; Get pointer to line
        jne   edb.line.copy.getlen  ; Only continue if pointer is set
        jmp   edb.line.copy.index   ; Skip copy stuff, only update index
        ;------------------------------------------------------
        ; Get source line length
        ;------------------------------------------------------ 
edb.line.copy.getlen:                                        
        mov   *tmp0,tmp1            ; Get line length
        mov   tmp1,@rambuf          ; \ Save length of line        
        inct  @rambuf               ; / Consider length of line prefix too
        mov   tmp0,@rambuf+4        ; Source memory address for block copy
        ;------------------------------------------------------
        ; Sanity check on line length
        ;------------------------------------------------------        
        ci    tmp1,80               ; \ Continue if length <= 80
        jle   edb.line.copy.prepare ; /         
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
        ;------------------------------------------------------
        ; 1: Prepare pointers for editor buffer in d000-dfff
        ;------------------------------------------------------
edb.line.copy.prepare:
        a     @w$1000,@edb.top.ptr
        a     @w$1000,@edb.next_free.ptr
                                    ; The editor buffer SAMS page for the target
                                    ; line will be mapped into memory region
                                    ; d000-dfff (instead of usual c000-cfff)
                                    ;
                                    ; This allows normal memory copy routine
                                    ; to copy source line to target line.
        ;------------------------------------------------------
        ; 2: Check if highest SAMS page needs to be increased
        ;------------------------------------------------------ 
        bl    @edb.adjust.hipage    ; Check and increase highest SAMS page
                                    ; \ i  @edb.next_free.ptr = Pointer to next
                                    ; /                         free line
        ;------------------------------------------------------
        ; 3: Set parameters for copy line
        ;------------------------------------------------------                                     
        mov   @rambuf+4,tmp0        ; Pointer to source line
        mov   @edb.next_free.ptr,tmp1
                                    ; Pointer to space for new target line
                                
        mov   @rambuf,tmp2          ; Set number of bytes to copy
        ;------------------------------------------------------
        ; 4: Copy line
        ;------------------------------------------------------ 
edb.line.copy.line:
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; 5: Restore pointers to default memory region
        ;------------------------------------------------------ 
        s     @w$1000,@edb.top.ptr
        s     @w$1000,@edb.next_free.ptr
                                    ; Restore memory c000-cfff region for
                                    ; pointers to top of editor buffer and
                                    ; next line

        mov   @edb.next_free.ptr,@rambuf+6   
                                    ; Save pointer to target line
        ;------------------------------------------------------
        ; 6: Restore SAMS page c000-cfff as before copy
        ;------------------------------------------------------ 
        mov   @edb.sams.page,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; 7: Restore SAMS page d000-dfff as before copy
        ;------------------------------------------------------ 
        mov   @tv.sams.d000,tmp0
        li    tmp1,>d000
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; 8: Align pointer to multiple of 16 memory address
        ;------------------------------------------------------                                     
        a     @rambuf,@edb.next_free.ptr
                                       ; Add length of line

        mov   @edb.next_free.ptr,tmp0  ; \ Round up to next multiple of 16.
        neg   tmp0                     ; | tmp0 = tmp0 + (-tmp0 & 15)
        andi  tmp0,15                  ; | Hacker's Delight 2nd Edition
        a     tmp0,@edb.next_free.ptr  ; / Chapter 2
        ;------------------------------------------------------
        ; 9: Update index
        ;------------------------------------------------------
edb.line.copy.index:
        mov   @rambuf+2,@parm1      ; Line number of target line
        mov   @rambuf+6,@parm2      ; Pointer to new line
        mov   @edb.sams.hipage,@parm3 
                                    ; SAMS page to use

        bl    @idx.entry.update     ; Update index
                                    ; \ i  parm1 = Line number in editor buffer
                                    ; | i  parm2 = pointer to line in 
                                    ; |            editor buffer
                                    ; / i  parm3 = SAMS page        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.copy.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
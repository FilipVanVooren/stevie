* FILE......: fm.browse.asm
* Purpose...: File Manager - File browse support routines


*---------------------------------------------------------------
* Increase/Decrease last-character of current filename
*---------------------------------------------------------------
* bl   @fm.browse.fname.suffix
*--------------------------------------------------------------- 
* INPUT
* parm1        = Pointer to device and filename
* parm2        = Increase (>FFFF) or Decrease (>0000) ASCII
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.browse.fname.suffix.incdec:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get pointer to filename
        jeq   fm.browse.fname.suffix.exit
                                    ; Exit early if pointer is nill

        ci    tmp0,txt.newfile
        jeq   fm.browse.fname.suffix.exit
                                    ; Exit early if "New file"
        ;------------------------------------------------------
        ; Get last character in filename
        ;------------------------------------------------------
        movb  *tmp0,tmp1            ; Get length of current filename
        srl   tmp1,8                ; MSB to LSB

        a     tmp1,tmp0             ; Move to last character
        clr   tmp1
        movb  *tmp0,tmp1            ; Get character
        srl   tmp1,8                ; MSB to LSB
        jeq   fm.browse.fname.suffix.exit
                                    ; Exit early if empty filename
        ;------------------------------------------------------
        ; Check mode (increase/decrease) character ASCII value
        ;------------------------------------------------------        
        mov   @parm2,tmp2           ; Get mode
        jeq   fm.browse.fname.suffix.dec    
                                    ; Decrease ASCII if mode = 0
        ;------------------------------------------------------
        ; Increase ASCII value last character in filename
        ;------------------------------------------------------
fm.browse.fname.suffix.inc:
        ci    tmp1,48               ; ASCI  48 (char 0) ?
        jlt   fm.browse.fname.suffix.inc.crash
        ci    tmp1,57               ; ASCII 57 (char 9) ?
        jlt   !                     ; Next character
        jeq   fm.browse.fname.suffix.inc.alpha
                                    ; Swith to alpha range A..Z
        ci    tmp1,90               ; ASCII 132 (char Z) ?
        jeq   fm.browse.fname.suffix.exit
                                    ; Already last alpha character, so exit
        jlt   !                     ; Next character
        ;------------------------------------------------------
        ; Invalid character, crash and burn
        ;------------------------------------------------------
fm.browse.fname.suffix.inc.crash:        
        mov   r11,@>ffce            ; \ Save caller address   
        bl    @cpu.crash            ; / Crash and halt system     
        ;------------------------------------------------------
        ; Increase ASCII value last character in filename
        ;------------------------------------------------------
!       inc   tmp1                  ; Increase ASCII value
        jmp   fm.browse.fname.suffix.store
fm.browse.fname.suffix.inc.alpha:        
        li    tmp1,65               ; Set ASCII 65 (char A)        
        jmp   fm.browse.fname.suffix.store
        ;------------------------------------------------------
        ; Decrease ASCII value last character in filename
        ;------------------------------------------------------
fm.browse.fname.suffix.dec:        
        ci    tmp1,48               ; ASCII 48 (char 0) ?
        jeq   fm.browse.fname.suffix.exit
                                    ; Already first numeric character, so exit
        ci    tmp1,57               ; ASCII 57 (char 9) ?
        jle   !                     ; Previous character
        ci    tmp1,65               ; ASCII 65 (char A) ?
        jeq   fm.browse.fname.suffix.dec.numeric
                                    ; Switch to numeric range 0..9
        jlt   fm.browse.fname.suffix.inc.crash
                                    ; Invalid character                                    
        ci    tmp1,132              ; ASCII 132 (char Z) ?
        jeq   fm.browse.fname.suffix.exit        
!       dec   tmp1                  ; Decrease ASCII value
        jmp   fm.browse.fname.suffix.store
fm.browse.fname.suffix.dec.numeric:
        li    tmp1,57               ; Set ASCII 57 (char 9)
        ;------------------------------------------------------
        ; Store updatec character
        ;------------------------------------------------------
fm.browse.fname.suffix.store:
        sla   tmp1,8                ; LSB to MSB
        movb  tmp1,*tmp0            ; Store updated character
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.suffix.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
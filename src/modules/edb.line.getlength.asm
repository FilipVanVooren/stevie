* FILE......: edb.line.getlength.asm
* Purpose...: Get length of specified line in editor buffer

***************************************************************
* edb.line.getlength
* Get length of specified line
***************************************************************
*  bl   @edb.line.getlength
*--------------------------------------------------------------
* INPUT
* @parm1 = Line number (base 0)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of line
* @outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.line.getlength:
        .pushregs 1                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @outparm1             ; Reset length
        clr   @outparm2             ; Reset SAMS bank
        ;------------------------------------------------------
        ; Exit if requested line beyond editor buffer
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; \ 
        inc   tmp0                  ; /  base 1

        c     tmp0,@edb.lines       ; Requested line at BOT?
        jle   !                     ; No, continue processing
        jmp   edb.line.getlength.null
                                    ; Set length 0 and exit early
        ;------------------------------------------------------
        ; Map SAMS page
        ;------------------------------------------------------
!       mov   @parm1,tmp0           ; Get line

        bl    @edb.line.mappage     ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line 
                                    ; / o  outparm2 = SAMS page

        mov   @outparm1,tmp0        ; Store pointer in tmp0
        jeq   edb.line.getlength.null
                                    ; Set length to 0 if null-pointer
        ;------------------------------------------------------
        ; Process line prefix and exit
        ;------------------------------------------------------
        mov   *tmp0,tmp1            ; Get length into tmp1
        mov   tmp1,@outparm1        ; Save length                
        jmp   edb.line.getlength.exit
        ;------------------------------------------------------
        ; Set length to 0 if null-pointer
        ;------------------------------------------------------
edb.line.getlength.null:
        clr   @outparm1             ; Set length to 0, was a null-pointer
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.line.getlength.exit:
        .popregs 1                  ; Pop registers and return to caller        

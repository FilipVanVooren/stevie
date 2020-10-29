* FILE......: edb.line.getlen.asm
* Purpose...: Stevie Editor - Editor Buffer get line length

*//////////////////////////////////////////////////////////////
*       Stevie Editor - Editor Buffer get line length
*//////////////////////////////////////////////////////////////


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
* @outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.line.getlength:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @outparm1             ; Reset length
        clr   @outparm2             ; Reset SAMS bank
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
        ;------------------------------------------------------
        ; Map SAMS page if required
        ;------------------------------------------------------
        c     @outparm2,@edb.sams.page
        jeq   !                     ; Page mapped, continue
        ;------------------------------------------------------
        ; Map SAMS page
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get line

        bl    @xmem.edb.sams.mappage
                                    ; Activate editor buffer SAMS page for line
                                    ; \ i  tmp0     = Line number
                                    ; | o  outparm1 = Pointer to line 
                                    ; / o  outparm2 = SAMS page

        mov   @outparm1,tmp0        ; Store pointer in tmp0
        ;------------------------------------------------------
        ; Process line prefix
        ;------------------------------------------------------
!       mov   *tmp0,tmp0            ; Get length into tmp0
        mov   tmp0,@outparm1        ; Save length                
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        ci    tmp0,81               ; Line length <= 80 ?
        jlt   edb.line.getlength.exit
                                    ; Yes, exit
        ;------------------------------------------------------
        ; Crash the system
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.getlength.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
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
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
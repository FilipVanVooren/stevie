* FILE......: edb.line.mappage.asm
* Purpose...: Editor buffer SAMS setup


***************************************************************
* edb.line.mappage
* Activate editor buffer SAMS page for line
***************************************************************
* bl  @edb.line.mappage
* 
* tmp0 = Line number in editor buffer (base 1)
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Pointer to line in editor buffer
* outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
***************************************************************
edb.line.mappage:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------
        c     tmp0,@edb.lines       ; Non-existing line?
        jle   edb.line.mappage.lookup
                                    ; All checks passed, continue
                                    ;-------------------------- 
                                    ; Assert failed
                                    ;--------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Lookup SAMS page for line in parm1
        ;------------------------------------------------------
edb.line.mappage.lookup:
        mov   tmp0,@parm1           ; Set line number in editor buffer

        bl    @idx.pointer.get      ; Get pointer to line
                                    ; \ i  parm1    = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page

        mov   @outparm2,tmp0        ; SAMS page
        mov   @outparm1,tmp1        ; Pointer to line        
        jeq   edb.line.mappage.exit ; Nothing to page-in if NULL pointer 
                                    ; (=empty line)
        ;------------------------------------------------------        
        ; Determine if requested SAMS page is already active
        ;------------------------------------------------------
        c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
        jeq   edb.line.mappage.exit ; Request page already active, so exit
        ;------------------------------------------------------
        ; Activate requested SAMS page
        ;-----------------------------------------------------
        bl    @xsams.page.set       ; Switch SAMS memory page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        mov   @outparm2,@tv.sams.c000
                                    ; Set page in shadow registers

        mov   @outparm2,@edb.sams.page 
                                    ; Set current SAMS page                                    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.mappage.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller    

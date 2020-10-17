* FILE......: mem.asm
* Purpose...: Stevie Editor - Memory management (SAMS)

*//////////////////////////////////////////////////////////////
*                  Stevie Editor - Memory Management
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.sams.layout
* Setup SAMS memory pages for Stevie
***************************************************************
* bl  @mem.sams.layout
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
mem.sams.layout:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @sams.layout
              data mem.sams.layout.data

        bl    @sams.layout.copy
              data tv.sams.2000     ; Get SAMS windows

        mov   @tv.sams.c000,@edb.sams.page
        mov   @edb.sams.page,@edb.sams.hipage                  
                                    ; Track editor buffer SAMS page
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.layout.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* mem.edb.sams.mappage
* Activate editor buffer SAMS page for line
***************************************************************
* bl  @mem.edb.sams.mappage
*     data p0
*--------------------------------------------------------------
* p0 = Line number in editor buffer
*--------------------------------------------------------------
* bl  @xmem.edb.sams.mappage
* 
* tmp0 = Line number in editor buffer
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Pointer to line in editor buffer
* outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
***************************************************************
mem.edb.sams.mappage:
        mov   *r11+,tmp0            ; Get p0
xmem.edb.sams.mappage:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        c     tmp0,@edb.lines       ; Non-existing line?
        jle   mem.edb.sams.mappage.lookup
                                    ; All checks passed, continue
                                    ;-------------------------- 
                                    ; Sanity check failed
                                    ;--------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Lookup SAMS page for line in parm1
        ;------------------------------------------------------
mem.edb.sams.mappage.lookup:        
        bl    @idx.pointer.get      ; Get pointer to line
                                    ; \ i  parm1    = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page

        mov   @outparm2,tmp0        ; SAMS page
        mov   @outparm1,tmp1        ; Pointer to line        
        jeq   mem.edb.sams.mappage.exit
                                    ; Nothing to page-in if NULL pointer 
                                    ; (=empty line)
        ;------------------------------------------------------        
        ; Determine if requested SAMS page is already active
        ;------------------------------------------------------
        c     @tv.sams.c000,tmp0    ; Compare with active page editor buffer
        jeq   mem.edb.sams.mappage.exit
                                    ; Request page already active. Exit.
        ;------------------------------------------------------
        ; Activate requested SAMS page
        ;-----------------------------------------------------
        bl    @xsams.page.set       ; Switch SAMS memory page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        mov   @outparm2,@tv.sams.c000
                                    ; Set page in shadow registers
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.edb.sams.mappage.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
        



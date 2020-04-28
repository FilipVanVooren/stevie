* FILE......: mem.asm
* Purpose...: TiVi Editor - Memory management (SAMS)

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Memory Management
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.sams.layout
* Setup SAMS memory pages for TiVi
***************************************************************
* bl  @mem.setup.sams.layout
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
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.sams.layout.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS page layout table for TiVi (16 words)
*--------------------------------------------------------------
mem.sams.layout.data:
        data  >2000,>0002           ; >2000-2fff, SAMS page >02
        data  >3000,>0003           ; >3000-3fff, SAMS page >03
        data  >a000,>000a           ; >a000-afff, SAMS page >0a
        data  >b000,>000b           ; >b000-bfff, SAMS page >0b
        data  >c000,>000c           ; >c000-cfff, SAMS page >0c
        data  >d000,>0030           ; >d000-dfff, SAMS page >30
        data  >e000,>0010           ; >e000-efff, SAMS page >10
        data  >f000,>0011           ; >f000-ffff, SAMS page >11


***************************************************************
* mem.edb.sams.pagein
* Activate editor buffer SAMS page for line
***************************************************************
* bl  @mem.edb.sams.pagein
*     data p0
*--------------------------------------------------------------
* p0 = Line number in editor buffer
*--------------------------------------------------------------
* bl  @xmem.edb.sams.pagein
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
mem.edb.sams.pagein:
        mov   *r11+,tmp0            ; Get p0
xmem.edb.sams.pagein:
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
        jlt   mem.edb.sams.pagein.lookup
                                    ; All checks passed, continue
                                    ;-------------------------- 
                                    ; Sanity check failed
                                    ;--------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Lookup SAMS page for line in parm1
        ;------------------------------------------------------
mem.edb.sams.pagein.lookup:        
        bl    @idx.pointer.get      ; Get pointer to line
                                    ; \ i  parm1    = Line number
                                    ; | o  outparm1 = Pointer to line
                                    ; / o  outparm2 = SAMS page

        mov   @outparm2,tmp0        ; SAMS page
        mov   @outparm1,tmp1        ; Pointer to line        
        jeq   mem.edb.sams.pagein.exit
                                    ; Nothing to page-in if NULL pointer 
                                    ; (=empty line)
        ;------------------------------------------------------        
        ; Determine if requested SAMS page is already active
        ;------------------------------------------------------
        c     @tv.sams.d000,tmp0    ; Compare with active page editor buffer
        jeq   mem.edb.sams.pagein.exit
                                    ; Request page already active. Exit.
        ;------------------------------------------------------
        ; Activate requested SAMS page
        ;-----------------------------------------------------
        bl    @xsams.page.set       ; Switch SAMS memory page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        mov   @outparm2,@tv.sams.d000
                                    ; Set page in shadow registers
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.edb.sams.pagein.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
        



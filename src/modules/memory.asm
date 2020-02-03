* FILE......: memory.asm
* Purpose...: TiVi Editor - Memory management (SAMS)

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Memory Management
*//////////////////////////////////////////////////////////////

***************************************************************
* mem.setup.sams.layout
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
mem.setup.sams.layout:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Set SAMS standard layout
        ;------------------------------------------------------        
        bl    @sams.layout
              data mem.sams.layout.data
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.setup.sams.layout.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
***************************************************************
* SAMS page layout table for TiVi (16 words)
*--------------------------------------------------------------
mem.sams.layout.data:
        data  >2000,>0000           ; >2000-2fff, SAMS page >00
        data  >3000,>0001           ; >3000-3fff, SAMS page >01
        data  >a000,>0002           ; >a000-afff, SAMS page >02
        data  >b000,>0003           ; >b000-bfff, SAMS page >03
        data  >c000,>0004           ; >c000-cfff, SAMS page >04
        data  >d000,>0005           ; >d000-dfff, SAMS page >05
        data  >e000,>0006           ; >e000-efff, SAMS page >06
        data  >f000,>0007           ; >f000-ffff, SAMS page >07



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
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Save tmp0
        dect  stack
        mov   tmp1,*stack           ; Save tmp1
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        c     tmp0,@edb.lines       ; Non-existing line?
        jgt   !                     ; Yes, crash!
        
        jmp   mem.edb.sams.pagein.lookup
                                    ; All checks passed, continue

                                    ;-------------------------- 
                                    ; Sanity check failed
                                    ;--------------------------
!       mov   r11,@>ffce            ; \ Save caller address        
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
        mov   @outparm1,tmp1        ; Memory address        
        ;------------------------------------------------------
        ; Activate SAMS page where specified line is stored
        ;------------------------------------------------------
        bl    @xsams.page.set       ; Switch SAMS memory page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
mem.edb.sams.pagein.exit
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

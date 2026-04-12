* FILE......: edb.hipage.alloc.asm
* Purpose...: Editor buffer utilities


***************************************************************
* edb.hipage.alloc
* Check and increase highest SAMS page of editor buffer
***************************************************************
*  bl   @edb.hipage.alloc
*--------------------------------------------------------------
* INPUT
* @edb.next_free.ptr = Pointer to next free line
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.hipage.alloc:
        .pushregs 1                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; 1a. Check if highest SAMS page needs to be increased
        ;------------------------------------------------------
edb.hipage.alloc.check_setpage:
        mov   @edb.next_free.ptr,tmp0
                                    ;--------------------------
                                    ; Check for page overflow
                                    ;--------------------------
        andi  tmp0,>0fff            ; Get rid of highest nibble
        ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
        ci    tmp0,>1000 - 16       ; 4K boundary reached?
        jlt   edb.hipage.alloc.setpage
                                    ; Not yet, don't increase SAMS page
        ;------------------------------------------------------
        ; 1b. Increase highest SAMS page (copy-on-write!)
        ;------------------------------------------------------
        inc   @edb.sams.hipage      ; Set highest SAMS page
        mov   @edb.top.ptr,@edb.next_free.ptr
                                    ; Start at top of SAMS page again
        ;------------------------------------------------------
        ; 1c. Switch to SAMS page and exit
        ;------------------------------------------------------
edb.hipage.alloc.setpage:
        mov   @edb.sams.hipage,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        jmp   edb.hipage.alloc.exit
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------
edb.hipage.alloc.crash:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.hipage.alloc.exit:
        .popregs 1                  ; Pop registers and return to caller        

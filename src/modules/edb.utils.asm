* FILE......: edb.utils.asm
* Purpose...: Editor buffer utilities


***************************************************************
* edb.adjust.hipage
* Check and increase highest SAMS page of editor buffer
***************************************************************
*  bl   @edb.adjust.hipage
*--------------------------------------------------------------
* INPUT
* @edb.next_free.ptr = Pointer to next free line
*--------------------------------------------------------------
* OUTPUT
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.adjust.hipage:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; 1a: Check if highest SAMS page needs to be increased
        ;------------------------------------------------------ 
edb.adjust.hipage.check_setpage:
        mov   @edb.next_free.ptr,tmp0
                                    ;--------------------------
                                    ; Sanity check
                                    ;-------------------------- 
        ci    tmp0,edb.top + edb.size
                                    ; Insane address ?
        jgt   edb.adjust.hipage.crash
                                    ; Yes, crash!
                                    ;--------------------------
                                    ; Check for page overflow
                                    ;-------------------------- 
        andi  tmp0,>0fff            ; Get rid of highest nibble        
        ai    tmp0,82               ; Assume line of 80 chars (+2 bytes prefix)
        ci    tmp0,>1000 - 16       ; 4K boundary reached?
        jlt   edb.adjust.hipage.setpage
                                    ; Not yet, don't increase SAMS page
        ;------------------------------------------------------
        ; 1b: Increase highest SAMS page (copy-on-write!)
        ;------------------------------------------------------ 
        inc   @edb.sams.hipage      ; Set highest SAMS page                     
        mov   @edb.top.ptr,@edb.next_free.ptr
                                    ; Start at top of SAMS page again
        ;------------------------------------------------------
        ; 1c: Switch to SAMS page and exit
        ;------------------------------------------------------ 
edb.adjust.hipage.setpage:        
        mov   @edb.sams.hipage,tmp0
        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        jmp   edb.adjust.hipage.exit
        ;------------------------------------------------------
        ; Check failed, crash CPU!
        ;------------------------------------------------------  
edb.adjust.hipage.crash:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.adjust.hipage.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0          
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller        
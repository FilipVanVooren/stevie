* FILE......: edb.clear.sams.asm
* Purpose...: Clear SAMS pages of editor buffer

***************************************************************
* edb.clear
* Clear SAMS pages of editor buffer
***************************************************************
*  bl   @edb.clear.sams
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edb.clear.sams:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------        
        ; Initialize
        ;------------------------------------------------------     
        mov   @edb.sams.hipage,tmp2 ; Highest SAMS page used
        ;------------------------------------------------------        
        ; Clear SAMS memory
        ;------------------------------------------------------             
edb.clear.sams.loop:
        mov   tmp2,tmp0             ; SAMS page
        li    tmp1,>c000            ; Memory region to map

        bl    @xsams.page.set       ; Switch SAMS memory page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address

        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        bl    @film                 ; \ Clear memory
              data >c000,0,4096     ; / Overwrites tmp0-tmp3 (!)

        mov   *stack+,tmp2          ; Pop tmp2

        dec   tmp2 
        c     tmp2,@edb.sams.lopage ; First page reached?
        jlt   !                     ; Yes, prepare for exit
        jmp   edb.clear.sams.loop   ; No, next iteration
        ;------------------------------------------------------
        ; Reset boundaries and current SAMS page
        ;------------------------------------------------------      
!       mov   @edb.sams.lopage,tmp0 ; \
        mov   tmp0,@edb.sams.page   ; | Boundaries
        mov   tmp0,@edb.sams.hipage ; / 

        mov   @edb.top.ptr,tmp1
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0 = SAMS page number
                                    ; / i  tmp1 = Memory address

        mov   @edb.sams.hipage,@tv.sams.c000
                                    ; Sync SAMS window. Important!      
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.clear.sams.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

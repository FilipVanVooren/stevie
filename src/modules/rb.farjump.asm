* FILE......: rb.farjump.asm
* Purpose...: Trampoline to routine in other ROM bank


***************************************************************
* rb.farjump - Jump to routine in specified bank
***************************************************************
*  bl   @rb.farjump
*       DATA P0,P1
*--------------------------------------------------------------
*  P0 = Write address of target ROM bank
*  P1 = Vector address with target address to jump to
*  P2 = Write address of source ROM bank
*--------------------------------------------------------------
*  bl @xrb.farjump
*
*  TMP0 = Write address of target ROM bank
*  TMP1 = Vector address with target address to jump to
*  TMP2 = Write address of source ROM bank
********|*****|*********************|**************************
rb.farjump:
        mov   *r11+,tmp0            ; P0
        mov   *r11+,tmp1            ; P1
        mov   *r11+,tmp2            ; P2
        ;------------------------------------------------------
        ; Push registers to value stack (but not r11!)
        ;------------------------------------------------------
xrb.farjump:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;------------------------------------------------------
        ; Push to farjump return stack
        ;------------------------------------------------------
        ci    tmp0,>6002            ; Invalid bank write address?
        jlt   rb.farjump.bankswitch.failed1
                                    ; Crash if null value in bank write address

        mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
        dect  tmp3
        mov   r11,*tmp3             ; Push return address to farjump stack
        dect  tmp3
        mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
        mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer
        ;------------------------------------------------------
        ; Bankswitch to target bank
        ;------------------------------------------------------
rb.farjump.bankswitch:
        clr   *tmp0                 ; Switch to target ROM bank        
        mov   *tmp1,tmp0            ; Deref value in vector address
        jeq   rb.farjump.bankswitch.failed1
                                    ; Crash if null-pointer in vector
        jmp   rb.farjump.bankswitch.call
                                    ; Call function in target bank
        ;------------------------------------------------------
        ; Sanity check 1 failed before bank-switch
        ;------------------------------------------------------
rb.farjump.bankswitch.failed1:        
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Call function in target bank
        ;------------------------------------------------------
rb.farjump.bankswitch.call:
        bl    *tmp0                 ; Call function
        ;------------------------------------------------------
        ; Bankswitch back to source bank
        ;------------------------------------------------------
rb.farjump.return:
        mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
        mov   *tmp0,tmp1            ; Get bank write address of caller
        jeq   rb.farjump.bankswitch.failed2
                                    ; Crash if null-pointer in address

        clr   *tmp0+                ; Remove bank write address from
                                    ; farjump stack

        mov   *tmp0,r11             ; Get return addr of caller for return

        clr   *tmp0+                ; Remove return address of caller from 
                                    ; farjump stack

        ci    r11,>6000
        jlt   rb.farjump.bankswitch.failed2
        ci    r11,>7fff
        jgt   rb.farjump.bankswitch.failed2
        
        mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
        clr   *tmp1                 ; Switch to bank of caller  
        jmp   rb.farjump.exit
        ;------------------------------------------------------
        ; Sanity check 2 failed after bank-switch
        ;------------------------------------------------------
rb.farjump.bankswitch.failed2:        
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system              
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
rb.farjump.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        b     *r11                  ; Return to caller
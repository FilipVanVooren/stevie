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
        ;------------------------------------------------------
        ; Call function in target bank
        ;------------------------------------------------------
        bl    *tmp0                 ; Call function
        ;------------------------------------------------------
        ; Bankswitch back to source bank
        ;------------------------------------------------------
rb.farjump.return:
        mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
        mov   *tmp0+,tmp1           ; Get bank write address of caller
        mov   *tmp0+,r11            ; Get return address of caller for return

        mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer
        clr   *tmp1                 ; Switch to bank of caller
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
rb.farjump.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        b     *r11                  ; Return to caller
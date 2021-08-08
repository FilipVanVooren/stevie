* FILE......: rom.farjump.asm
* Purpose...: Trampoline to routine in other ROM bank

***************************************************************
* rom.farjump - Jump to routine in specified bank
***************************************************************
*  bl   @rom.farjump
*       data p0,p1
*--------------------------------------------------------------
*  p0 = Write address of target ROM bank
*  p1 = Vector address with target address to jump to
*  p2 = Write address of source ROM bank
*--------------------------------------------------------------
*  bl @xrom.farjump
*
*  tmp0 = Write address of target ROM bank
*  tmp1 = Vector address with target address to jump to
*  tmp2 = Write address of source ROM bank
********|*****|*********************|**************************
rom.farjump:
        mov   *r11+,tmp0            ; P0
        mov   *r11+,tmp1            ; P1
        mov   *r11+,tmp2            ; P2
        ;------------------------------------------------------
        ; Push registers to value stack (but not r11!)
        ;------------------------------------------------------
xrom.farjump:
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
        ci    tmp0,>6000            ; Invalid bank write address?
        jlt   rom.farjump.bankswitch.failed1
                                    ; Crash if bogus value in bank write address

        mov   @tv.fj.stackpnt,tmp3  ; Get farjump stack pointer
        dect  tmp3
        mov   r11,*tmp3             ; Push return address to farjump stack
        dect  tmp3
        mov   tmp2,*tmp3            ; Push source ROM bank to farjump stack
        mov   tmp3,@tv.fj.stackpnt  ; Set farjump stack pointer

        .ifeq device.fg99.mode.adv,1
        jmp   rom.farjump.bankswitch.tgt.advfg99
        .endif

        ;------------------------------------------------------
        ; Bankswitch to target 8K ROM bank 
        ;------------------------------------------------------
rom.farjump.bankswitch.target.rom8k:
        clr   *tmp0                 ; Switch to target ROM bank 8K >6000
        jmp   rom.farjump.bankswitch.tgt.done
        ;------------------------------------------------------
        ; Bankswitch to target 4K ROM / 4K RAM banks (FG99 advanced mode)
        ;------------------------------------------------------
rom.farjump.bankswitch.tgt.advfg99:
        clr   *tmp0                 ; Switch to target ROM bank 4K >6000
        ai    tmp0,>0800
        clr   *tmp0                 ; Switch to target RAM bank 4K >7000
        ;------------------------------------------------------
        ; Bankswitch to target bank(s) completed
        ;------------------------------------------------------
rom.farjump.bankswitch.tgt.done:
        ;------------------------------------------------------
        ; Deref vector from @parm1 if >ffff
        ;------------------------------------------------------
        ci    tmp1,>ffff
        jne   !
        mov   @parm1,tmp1
        ;------------------------------------------------------
        ; Deref value in vector
        ;------------------------------------------------------
!       mov   *tmp1,tmp0            ; Deref value in vector address
        jeq   rom.farjump.bankswitch.failed1
                                    ; Crash if null-pointer in vector


        jmp   rom.farjump.bankswitch.call
                                    ; Call function in target bank
        ;------------------------------------------------------
        ; Assert 1 failed before bank-switch
        ;------------------------------------------------------
rom.farjump.bankswitch.failed1:        
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Call function in target bank
        ;------------------------------------------------------
rom.farjump.bankswitch.call:
        bl    *tmp0                 ; Call function
        ;------------------------------------------------------
        ; Bankswitch back to source bank
        ;------------------------------------------------------
rom.farjump.return:
        mov   @tv.fj.stackpnt,tmp0  ; Get farjump stack pointer
        mov   *tmp0,tmp1            ; Get bank write address of caller
        jeq   rom.farjump.bankswitch.failed2
                                    ; Crash if null-pointer in address

        clr   *tmp0+                ; Remove bank write address from
                                    ; farjump stack

        mov   *tmp0,r11             ; Get return addr of caller for return

        clr   *tmp0+                ; Remove return address of caller from 
                                    ; farjump stack

        ci    r11,>6000
        jlt   rom.farjump.bankswitch.failed2
        ci    r11,>7fff
        jgt   rom.farjump.bankswitch.failed2
        
        mov   tmp0,@tv.fj.stackpnt  ; Update farjump return stack pointer

        .ifeq device.fg99.mode.adv,1
        jmp   rom.farjump.bankswitch.src.advfg99
        .endif

        ;------------------------------------------------------
        ; Bankswitch to source 8K ROM bank 
        ;------------------------------------------------------
rom.farjump.bankswitch.src.rom8k:
        clr   *tmp1                 ; Switch to source ROM bank 8K >6000
        jmp   rom.farjump.exit
        ;------------------------------------------------------
        ; Bankswitch to source 4K ROM / 4K RAM banks (FG99 advanced mode)
        ;------------------------------------------------------
rom.farjump.bankswitch.src.advfg99:
        clr   *tmp1                 ; Switch to source ROM bank 4K >6000
        ai    tmp1,>0800
        clr   *tmp1                 ; Switch to source RAM bank 4K >7000
        jmp   rom.farjump.exit
        ;------------------------------------------------------
        ; Assert 2 failed after bank-switch
        ;------------------------------------------------------
rom.farjump.bankswitch.failed2:        
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system              
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
rom.farjump.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        b     *r11                  ; Return to caller
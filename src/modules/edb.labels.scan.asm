* FILE......: edb.labels.scan.asm
* Purpose...: Scan source code in editor buffer for labels

***************************************************************
* edb.labels.scan
* Scan source code in editor buffer for labels
***************************************************************
*  bl   @edb.labels.scan
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
edb.labels.scan
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
        bl    @cpu.crash            ; Should never get here        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
edb.labels.scan.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

; 
; Pop registers from stack and return to caller
; #1 = Highest register to pop (0-7)
;
 .defm popregs
    .ifeq #1, 7
        mov   *stack+,tmp7          ; Pop tmp7
    .endif
    .ifge #1, 6
        mov   *stack+,tmp6          ; Pop tmp6
    .endif
    .ifge #1, 5    
        mov   *stack+,tmp5          ; Pop tmp5
    .endif
    .ifge #1, 4
        mov   *stack+,tmp4          ; Pop tmp4
    .endif
    .ifge #1, 3
        mov   *stack+,tmp3          ; Pop tmp3
    .endif
    .ifge #1, 2
        mov   *stack+,tmp2          ; Pop tmp2
    .endif
    .ifge #1, 1
        mov   *stack+,tmp1          ; Pop tmp1        
    .endif
    .ifge #1, 0
        mov   *stack+,tmp0          ; Pop tmp0
    .endif
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
 .endm
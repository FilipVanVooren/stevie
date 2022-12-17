* FILE......: tv.uint16.pack.asm
* Purpose...: Pack string to 16bit unsigned integer

***************************************************************
* tv.uint16.pack
* Pack (number) string to 16bit unsigned integer
***************************************************************
* bl @tv.uint16.pack
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to input string (no length-byte prefix!)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = 16bit unsigned integer
* @outparm2 = 0 conversion ok, >FFFF invalid input
*--------------------------------------------------------------
* REMARK
* None
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, r0, r1
***************************************************************
tv.uint16.pack:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2        
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   r0,*stack             ; Push r0
        dect  stack
        mov   r1,*stack             ; Push r1
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Pointer to input string
        clr   tmp1                  ; Termination character >00
        clr   @outparm1             ; Reset output parameters 
        clr   @outparm2             ; Reset output parameters
        ;------------------------------------------------------
        ; Get string length
        ;------------------------------------------------------
        bl    @xstring.getlenc      ; Get length of C-style string
                                    ; \ i  tmp0   = Pointer to C-style string
                                    ; | i  tmp1   = Termination character
                                    ; / o  @waux1 = Length of string
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------
        mov   @waux1,tmp2           ; Get string length
        jeq   tv.uint16.pack.error  ; No input string given
        ci    tmp2,5                ; Maximum 5 digits ?
        jgt   tv.uint16.pack.error  ; Input string too long
        ;------------------------------------------------------
        ; Prepare register values
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Pointer to input string

        a     tmp2,tmp2             ; \ Starting offset in tv.uint16.mpy  
        ai    tmp2,-10              ; |    10 - (tmp2 * 2) 
        abs   tmp2                  ; /

        clr   tmp3                  ; Clear final uint16
        ;------------------------------------------------------
        ; Get character
        ;------------------------------------------------------
tv.uint16.pack.loop:
        movb  *tmp0+,tmp1           ; Get character
        srl   tmp1,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Character is ASCII 0 or blank (ASCII 32) ?
        ;------------------------------------------------------
        jeq   tv.uint16.pack.exit   ; End of string reached        
        ci    tmp1,32               ; Blank ?
        jeq   tv.uint16.pack.exit   ; End of string reached
        ;------------------------------------------------------
        ; Character in range 0..9 ?
        ;------------------------------------------------------
        ai    tmp1,-48              ; Remove ASCII offset        
        jlt   tv.uint16.pack.error  ; Invalid character, exit
        ci    tmp1,9
        jgt   tv.uint16.pack.error  ; Invalid character, exit
        ;------------------------------------------------------
        ; Get base 10 multiplier for digit
        ;------------------------------------------------------
        mov   @tv.uint16.mpy(tmp2),r0
        ;------------------------------------------------------
        ; Convert number to decimal 10 (final result in tmp3)
        ;------------------------------------------------------
        mpy   tmp1,r0               ; Multiply digit with r0, 32bit result is
                                    ; in r0 and r1. We need r1 (LSW)
        a     r1,tmp3               ; Add base10 value to final uint16
        ;------------------------------------------------------
        ; Prepare for next digit
        ;------------------------------------------------------
        inct  tmp2                  ; Update loop counter
        ci    tmp2,8                ; Last digit done?
        jle   tv.uint16.pack.loop   ; Next iteration                
        jmp   tv.uint16.pack.done   ; Done packing uint16, exit
        ;------------------------------------------------------
        ; Invalid character, stop packing and exit
        ;------------------------------------------------------
tv.uint16.pack.error:
        clr   @outparm1             ; Empty uint16
        seto  @outparm2             ; Invalid input string
        ;-------------------------------------------------------
        ; Save final uint16
        ;-------------------------------------------------------
tv.uint16.pack.done:
        mov   tmp3,@outparm1
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.uint16.pack.exit:
        mov   *stack+,r1            ; Pop r1
        mov   *stack+,r0            ; Pop r0
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
        ;-------------------------------------------------------
        ; Constants for base 10 mmultipliers
        ;-------------------------------------------------------
tv.uint16.mpy:
        data  10000,1000,100,10,1
 

* FILE......: tv.bcd.pack.asm
* Purpose...: Pack string as BCD (Binary Coded Decimal)

***************************************************************
* tv.bcd.pack
* Pack (number) string to BCD (Bynary Coded Decimal)
***************************************************************
* bl @tv.bcd.pack
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to input string (no length-byte prefix!)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Converted BCD
* @outparm2 = 0 conversion ok, >FFFF invalid input string
*--------------------------------------------------------------
* REMARKS
* nonw
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
***************************************************************
tv.bcd.pack:
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
        ;------------------------------------------------------
        ; Loop over string (5 bytes max)
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Pointer to input string
        clr   tmp1                  ; Work copy input character
        li    tmp2,5                ; Loop counter
        clr   tmp3                  ; Packed bcd
        ;------------------------------------------------------
        ; Get character
        ;------------------------------------------------------
tv.bcd.pack.loop:
        movb  *tmp0+,tmp1           ; Get character
        srl   tmp1,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Character is ASCII 0 or blank (ASCII 32) ?
        ;------------------------------------------------------
        jeq   tv.bcd.pack.done      ; End of string reached        
        ci    tmp1,32               ; Blank ?
        jeq   tv.bcd.pack.done      ; End of string reached
        ;------------------------------------------------------
        ; Character in range 0..9 ?
        ;------------------------------------------------------
        ai    tmp1,-48              ; Remove ASCII offset        
        jlt   tv.bcd.pack.error     ; Invalid character, exit
        ci    tmp1,9
        jgt   tv.bcd.pack.done      ; Invalid character, exit
        ;------------------------------------------------------
        ; Pack digit char to byte
        ;------------------------------------------------------
        c     @parm1,tmp0           ; Initial loop?
        jeq   !                     ; Yes, skip shift left
        sla   tmp3,4                ; Shift left bcd nibble
!       soc   tmp1,tmp3             ; (tmp1 or tmp3) -> Set digit in LSB bcd
        dec   tmp2                  ; Update loop counter
        jeq   tv.bcd.pack.done      ; Done packing bcd
        jmp   tv.bcd.pack.loop      ; Next iteration        
        ;------------------------------------------------------
        ; Invalid character, stop packing and exit
        ;------------------------------------------------------
tv.bcd.pack.error:
        clr   @outparm1             ; Reset BCD
        seto  @outparm2             ; Invalid input string
        jmp   tv.bcd.pack.exit      ; Exit
        ;------------------------------------------------------
        ; Done packing bcd
        ;------------------------------------------------------
tv.bcd.pack.done:
        mov   tmp3,@outparm1        ; Save final BCD
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.bcd.pack.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

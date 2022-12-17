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
* @uint16.packed = Packed uint16 in range 0-65534
*--------------------------------------------------------------
* Remark
* @uint16.packed = >FFFF (65535) indicates invalid input string
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
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
        ;------------------------------------------------------
        ; Loop over string (5 bytes max)
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Pointer to input string
        clr   tmp1                  ; Work copy input character
        li    tmp2,5                ; Loop counter
        clr   tmp3                  ; Packed uint16
        ;------------------------------------------------------
        ; Get character
        ;------------------------------------------------------
tv.uint16.pack.loop:
        movb  *tmp0+,tmp1           ; Get character
        srl   tmp1,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Character is ASCII 0 or blank (ASCII 32) ?
        ;------------------------------------------------------
        jeq   tv.uint16.pack.done   ; End of string reached        
        ci    tmp1,32               ; Blank ?
        jeq   tv.uint16.pack.done   ; End of string reached
        ;------------------------------------------------------
        ; Character in range 0..9 ?
        ;------------------------------------------------------
        ai    tmp1,-48              ; Remove ASCII offset        
        jlt   tv.uint16.pack.error  ; Invalid character, exit
        ci    tmp1,9
        jgt   tv.uint16.pack.done   ; Invalid character, exit
        ;------------------------------------------------------
        ; Pack digit char to byte
        ;------------------------------------------------------
        c     @parm1,tmp0           ; Initial loop?
        jeq   !                     ; Yes, skip shift left
        sla   tmp3,4                ; Shift left uint16 nibble
!       soc   tmp1,tmp3             ; (tmp1 or tmp3) -> Set digit in LSB uint16
        dec   tmp2                  ; Update loop counter
        jeq   tv.uint16.pack.done   ; Done packing uint16
        jmp   tv.uint16.pack.loop   ; Next iteration        
        ;------------------------------------------------------
        ; Invalid character, stop packing and exit
        ;------------------------------------------------------
tv.uint16.pack.error:
        seto  @uint16.packed        ; Invalid input string
        ;------------------------------------------------------
        ; Done packing uint16
        ;------------------------------------------------------
tv.uint16.pack.done:
        mov   tmp3,@uint16.packed   ; Save uint16
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.uint16.pack.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

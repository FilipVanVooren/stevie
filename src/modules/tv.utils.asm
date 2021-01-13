* FILE......: tv.utils.asm
* Purpose...: General purpose utility functions

***************************************************************
* tv.unpack.uint16
* Unpack 16bit unsigned integer to string
***************************************************************
* bl @tv.unpack.uint16
*--------------------------------------------------------------
* INPUT
* @parm1 = 16bit unsigned integer
*--------------------------------------------------------------
* OUTPUT
* @unpacked.string = Length-prefixed string with unpacked uint16
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
tv.unpack.uint16:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        bl    @mknum                ; Convert unsigned number to string
              data parm1            ; \ i p0  = Pointer to 16bit unsigned number
              data rambuf           ; | i p1  = Pointer to 5 byte string buffer
              byte 48               ; | i p2H = Offset for ASCII digit 0
              byte 32               ; / i p2L = Char for replacing leading 0's

        li    tmp0,unpacked.string
        clr   *tmp0+                ; Clear string 01
        clr   *tmp0+                ; Clear string 23
        clr   *tmp0+                ; Clear string 34

        bl    @trimnum              ; Trim unsigned number string
              data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
              data unpacked.string  ; | i p1  = Pointer to output buffer
              data 32               ; / i p2  = Padding char to match against
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.unpack.uint16.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller   





***************************************************************
* tv.pad.string
* pad string to specified length
***************************************************************
* bl @tv.pad.string
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to length-prefixed string
* @parm2 = Requested length
* @parm3 = Fill character
* @parm4 = Pointer to string buffer
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Pointer to padded string
*--------------------------------------------------------------
* Register usage
* none
***************************************************************        
tv.pad.string:
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
        ; Asserts
        ;------------------------------------------------------ 
        mov   @parm1,tmp0           ; \ Get string prefix (length-byte)
        movb  *tmp0,tmp2            ; /
        srl   tmp2,8                ; Right align
        mov   tmp2,tmp3             ; Make copy of length-byte for later use                

        c     tmp2,@parm2           ; String length > requested length? 
        jgt   tv.pad.string.panic   ; Yes, crash
        ;------------------------------------------------------
        ; Copy string to buffer
        ;------------------------------------------------------ 
        mov   @parm1,tmp0           ; Get source address
        mov   @parm4,tmp1           ; Get destination address
        inc   tmp2                  ; Also include length-byte in copy

        dect  stack
        mov   tmp3,*stack           ; Push tmp3 (get overwritten by xpym2m)

        bl    @xpym2m               ; Copy length-prefix string to buffer
                                    ; \ i  tmp0 = Source CPU memory address
                                    ; | i  tmp1 = Target CPU memory address
                                    ; / i  tmp2 = Number of bytes to copy

        mov   *stack+,tmp3          ; Pop tmp3                                    
        ;------------------------------------------------------
        ; Set length of new string
        ;------------------------------------------------------ 
        mov   @parm2,tmp0           ; Get requested length
        sla   tmp0,8                ; Left align
        mov   @parm4,tmp1           ; Get pointer to buffer
        movb  tmp0,*tmp1            ; Set new length of string
        a     tmp3,tmp1             ; \ Skip to end of string
        inc   tmp1                  ; /
        ;------------------------------------------------------
        ; Prepare for padding string
        ;------------------------------------------------------ 
        mov   @parm2,tmp2           ; \ Get number of bytes to fill
        s     tmp3,tmp2             ; |
        inc   tmp2                  ; /

        mov   @parm3,tmp0           ; Get byte to padd
        sla   tmp0,8                ; Left align
        ;------------------------------------------------------
        ; Right-pad string to destination length
        ;------------------------------------------------------ 
tv.pad.string.loop:
        movb  tmp0,*tmp1+           ; Pad character
        dec   tmp2                  ; Update loop counter
        jgt   tv.pad.string.loop    ; Next character

        mov   @parm4,@outparm1      ; Set pointer to padded string
        jmp   tv.pad.string.exit    ; Exit
        ;-----------------------------------------------------------------------
        ; CPU crash
        ;-----------------------------------------------------------------------
tv.pad.string.panic:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
tv.pad.string.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

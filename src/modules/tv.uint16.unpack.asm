* FILE......: tv.uint16.unpack.asm
* Purpose...: Unpack 16bit unsigned integer to string

***************************************************************
* tv.uint16.unpack
* Unpack 16bit unsigned integer to string
***************************************************************
* bl @tv.uint16.unpack
*--------------------------------------------------------------
* INPUT
* @parm1 = 16bit unsigned integer
*--------------------------------------------------------------
* OUTPUT
* @uint16.unpacked = Length-prefixed string with unpacked uint16
*                    (6 bytes max)
*--------------------------------------------------------------
* Register usage
* tmp0
***************************************************************
tv.uint16.unpack:
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

        li    tmp0,uint16.unpacked
        clr   *tmp0+                ; Clear string 01
        clr   *tmp0+                ; Clear string 23
        clr   *tmp0+                ; Clear string 34

        bl    @trimnum              ; Trim unsigned number string
              data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
              data uint16.unpacked  ; | i p1  = Pointer to output buffer
              data 32               ; / i p2  = Padding char to match against
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.uint16.unpack.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller   

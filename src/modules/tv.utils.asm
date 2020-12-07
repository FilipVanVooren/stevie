* FILE......: tv.utils.asm
* Purpose...: General purpose utility functions

***************************************************************
* tv.unpack.int
* Unpack 16bit unsigned integer to string
***************************************************************
* bl @tv.unpack.int
*--------------------------------------------------------------
* INPUT
* @parm1 = 16bit unsigned integer
*--------------------------------------------------------------
* OUTPUT
* @unpacked.num = Length-prefixed string with unpacked integer
*--------------------------------------------------------------
* Register usage
* none
***************************************************************
tv.unpack.int:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        bl    @mknum                ; Convert unsigned number to string
              data parm1            ; \ i p0  = Pointer to 16bit unsigned number
              data rambuf           ; | i p1  = Pointer to 5 byte string buffer
              byte 48               ; | i p2H = Offset for ASCII digit 0
              byte 32               ; / i p2L = Char for replacing leading 0's

        bl    @trimnum              ; Trim unsigned number string
              data rambuf           ; \ i p0  = Pointer to 5 byte string buffer
              data unpacked.num     ; | i p1  = Pointer to output string
              data 32               ; | i p2  = Padding char to match against
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.unpack.number:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   
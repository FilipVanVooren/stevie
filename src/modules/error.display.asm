
***************************************************************
* error.display
* Display error message
***************************************************************
* bl  @error.display
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to error message
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
error.display:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack        
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Display error message
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; \ Get length of string
        movb  *tmp0,tmp2            ; | 
        srl   tmp2,8                ; / Right align

        mov   @parm1,tmp0           ; Get error message
        li    tmp1,tv.error.msg     ; Set error message

        bl    @xpym2m               ; Copy length-prefix string to buffer
                                    ; \ i  tmp0 = Source CPU memory address
                                    ; | i  tmp1 = Target CPU memory address
                                    ; / i  tmp2 = Number of bytes to copy                      

        bl    @pane.errline.show    ; Display error message
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
error.display.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return      
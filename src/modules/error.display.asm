
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
        .pushregs 2                 ; Push return address and registers on stack
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
        .popregs 2                  ; Pop registers and return to caller        

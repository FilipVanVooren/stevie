* FILE......: errline.asm
* Purpose...: Stevie Editor - Error line utilities

***************************************************************
* errline.init
* Initialize error line
***************************************************************
* bl @errline.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
***************************************************************
errline.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        clr   @tv.error.visible     ; Set to hidden

        bl    @film
              data tv.error.msg,0,160

        li    tmp0,>A000            ; Length of error message (160 bytes)
        movb  tmp0,@tv.error.msg    ; Set length byte        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
errline.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


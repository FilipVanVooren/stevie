* FILE......: errpane.asm
* Purpose...: Error pane utilities

***************************************************************
* errpane.init
* Initialize error pane
***************************************************************
* bl @errpane.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
***************************************************************
errpane.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        clr   @tv.error.visible     ; Set to hidden
        li    tmp0,3
        mov   tmp0,@tv.error.rows   ; Number of rows in error pane

        bl    @film
              data tv.error.msg,0,80
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
errpane.exit:
        .popregs 2                  ; Pop registers and return to caller        

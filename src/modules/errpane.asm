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
        .pushregs 2                 ; Push return address and registers on stack
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

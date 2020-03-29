* FILE......: pane.topline.asm
* Purpose...: TiVi Editor - Pane top line

*//////////////////////////////////////////////////////////////
*              TiVi Editor - Pane top line
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.topline.draw
* Draw TiVi status top line
***************************************************************
* bl  @pane.topline.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.topline.draw:
        dect  stack
        mov   r11,*stack            ; Save return address
        mov   @wyx,@fb.yxsave
        ;------------------------------------------------------
        ; Show banner (line above frame buffer, not part of it)
        ;------------------------------------------------------
        bl    @hchar
              byte 0,0,1,34         ; Double line at top (left)
              byte 0,46,1,34        ; Double line at top (right)
              data EOL

        bl    @putat
              byte 0,34
              data txt.tivi         ; TiVi banner (middle)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.topline.exit:
        mov   @fb.yxsave,@wyx
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

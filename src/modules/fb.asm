* FILE......: fb.asm
* Purpose...: Stevie Editor - Framebuffer module

***************************************************************
* fb.init 
* Initialize framebuffer
***************************************************************
*  bl   @fb.init
*--------------------------------------------------------------
*  INPUT
*  none
*--------------------------------------------------------------
*  OUTPUT 
*  none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,fb.top
        mov   tmp0,@fb.top.ptr      ; Set pointer to framebuffer
        clr   @fb.topline           ; Top line in framebuffer
        clr   @fb.row               ; Current row=0
        clr   @fb.column            ; Current column=0

        li    tmp0,colrow 
        mov   tmp0,@fb.colsline     ; Columns per row=80

        li    tmp0,29
        mov   tmp0,@fb.scrrows      ; Physical rows on screen = 29
        mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb

        clr   @tv.pane.focus        ; Frame buffer has focus!
        seto  @fb.dirty             ; Set dirty flag (trigger screen update)
        ;------------------------------------------------------
        ; Clear frame buffer
        ;------------------------------------------------------
        bl    @film
        data  fb.top,>00,fb.size    ; Clear it all the way
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.init.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


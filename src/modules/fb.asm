* FILE......: fb.asm
* Purpose...: Initialize framebuffer

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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
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
        clr   @fb.vwco              ; Set view window column offset
 
        li    tmp0,pane.botrow-1    ; Framebuffer
        mov   tmp0,@fb.scrrows      ; Physical rows on screen for fb
        mov   tmp0,@fb.scrrows.max  ; Maximum number of physical rows for fb

        clr   @tv.pane.focus        ; Frame buffer has focus!
        clr   @fb.colorize          ; Don't colorize M1/M2 lines
        seto  @fb.dirty             ; Set dirty flag (trigger screen update)
        seto  @fb.status.dirty      ; Trigger refresh of status lines
        ;------------------------------------------------------
        ; Clear frame buffer
        ;------------------------------------------------------
        bl    @film
        data  fb.top,>00,fb.size    ; Clear it all the way
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.init.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

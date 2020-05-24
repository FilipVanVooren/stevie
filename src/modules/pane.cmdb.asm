* FILE......: pane.cmdb.asm
* Purpose...: Stevie Editor - Command Buffer pane

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Command Buffer pane
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.cmdb.draw
* Draw stevie Command Buffer
***************************************************************
* bl  @pane.cmdb.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.cmdb.draw:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Draw command buffer
        ;------------------------------------------------------
        bl    @cmdb.refresh          ; Refresh command buffer content

        bl    @vchar
              byte 18,0,4,1          ; Top left corner              
              byte 18,79,5,1         ; Top right corner              
              byte 19,0,6,9          ; Left vertical double line
              byte 19,79,7,9         ; Right vertical double line              
              byte 28,0,8,1          ; Bottom left corner
              byte 28,79,9,1         ; Bottom right corner
              data EOL

        bl    @hchar
              byte 18,1,3,78         ; Horizontal top line
              byte 28,1,3,78         ; Horizontal bottom line
              data EOL              
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        


***************************************************************
* pane.cmdb.show
* Show command buffer pane
***************************************************************
* bl @pane.cmdb.show
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
pane.cmdb.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Show command buffer pane
        ;------------------------------------------------------
        mov   @wyx,@cmdb.fb.yxsave
                                    ; Save YX position in frame buffer

        mov   @fb.scrrows.max,tmp0
        s     @cmdb.scrrows,tmp0
        mov   tmp0,@fb.scrrows      ; Resize framebuffer
        
        inct  tmp0                  ; Line below cmdb top border line
        sla   tmp0,8                ; LSB to MSB (Y), X=0
        inc   tmp0                  ; X=1
        mov   tmp0,@cmdb.yxtop      ; Set command buffer cursor

        seto  @cmdb.visible         ; Show pane

        li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
        mov   tmp0,@tv.pane.focus   ; /

        seto  @fb.dirty             ; Redraw framebuffer
        
pane.cmdb.show.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* pane.cmdb.hide
* Hide command buffer pane
***************************************************************
* bl @pane.cmdb.hide
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Hiding the command buffer automatically passes pane focus
* to frame buffer.
********|*****|*********************|**************************
pane.cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Hide command buffer pane
        ;------------------------------------------------------
        mov   @fb.scrrows.max,@fb.scrrows
                                    ; Resize framebuffer

        mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer

        clr   @cmdb.visible         ; Hide command buffer pane
        seto  @fb.dirty             ; Redraw framebuffer
        clr   @tv.pane.focus        ; Framebuffer has focus!

pane.cmdb.hide.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

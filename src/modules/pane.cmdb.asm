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
        ; Command buffer header line
        ;------------------------------------------------------
        mov   @cmdb.yxtop,@wyx      ; \
        mov   @cmdb.pantitle,tmp1   ; | Display pane title
        bl    @xutst0               ; / 

        bl    @setx
              data 14               ; Position cursor

        bl    @putstr               ; Display horizontal line
              data txt.cmdb.hbar
        ;------------------------------------------------------
        ; Display hint in status line
        ;------------------------------------------------------
        movb  @txt.cmdb.hint,tmp0   ; Get length byte of hint
        srl   tmp0,8                ; Right justify
        mov   tmp0,tmp2
        neg   tmp2
        ai    tmp2,80               ; Number of bytes to fill
        ai    tmp0,>0910            ; VDP start address (bottom status line)
        li    tmp1,32               ; Byte to fill

        bl    @xfilv                ; Clear line
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill

        bl    @putat                ; Display hint
              byte 29,0
              data txt.cmdb.hint
        
        ;------------------------------------------------------
        ; Command buffer content
        ;------------------------------------------------------
        bl    @cmdb.refresh         ; Refresh command buffer content
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
        
        sla   tmp0,8                ; LSB to MSB (Y), X=0
        mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line

        ai    tmp0,>0100
        mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
        inc   tmp0
        mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane

        seto  @cmdb.visible         ; Show pane
        seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)

        li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
        mov   tmp0,@tv.pane.focus   ; /

        bl    @cmdb.cmd.clear;      ; Clear current command        
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
        ;------------------------------------------------------
        ; Adjust frame buffer size if error pane visible
        ;------------------------------------------------------
        mov   @tv.error.visible,@tv.error.visible
        jeq   !  
        dect  @fb.scrrows           
        ;------------------------------------------------------
        ; Hide command buffer pane (rest)
        ;------------------------------------------------------
!       mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
        clr   @cmdb.visible         ; Hide command buffer pane
        seto  @fb.dirty             ; Redraw framebuffer
        clr   @tv.pane.focus        ; Framebuffer has focus!
        ;------------------------------------------------------
        ; Clear status line
        ;------------------------------------------------------
        bl    @hchar
              byte 29,0,32,80
              data EOL
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.hide.exit:        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

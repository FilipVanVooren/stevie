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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------        
        ; Command buffer header line
        ;------------------------------------------------------
        mov   @cmdb.yxtop,@wyx      ; \
        mov   @cmdb.panhead,tmp1    ; | Display pane header
        bl    @xutst0               ; / 

        bl    @setx
              data 14               ; Position cursor

        bl    @putstr               ; Display horizontal line
              data txt.cmdb.hbar
        ;------------------------------------------------------
        ; Clear lines after prompt in command buffer
        ;------------------------------------------------------
        mov   @cmdb.cmdlen,tmp0     ; \
        srl   tmp0,8                ; | Set cursor after command prompt
        a     @cmdb.yxprompt,tmp0   ; |
        mov   tmp0,@wyx             ; /

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.                              
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        li    tmp1,32

        mov   @cmdb.cmdlen,tmp2     ; \
        srl   tmp2,8                ; | Determine number of bytes to fill.
        neg   tmp2                  ; | Based on command & prompt length
        ai    tmp2,2*80 - 1         ; /

        bl    @xfilv                ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        ;------------------------------------------------------
        ; Display pane hint in command buffer
        ;------------------------------------------------------
        li    tmp0,>1c00            ; Y=28, X=0
        mov   tmp0,@parm1           ; Set parameter
        mov   @cmdb.panhint,@parm2  ; Pane hint to display

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = Pointer to string with hint
                                    ; / i  parm2 = YX position
        ;------------------------------------------------------
        ; Display keys in status line
        ;------------------------------------------------------
        li    tmp0,>1d00            ; Y = 29, X=0
        mov   tmp0,@parm1           ; Set parameter
        mov   @cmdb.pankeys,@parm2  ; Pane hint to display

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = Pointer to string with hint
                                    ; / i  parm2 = YX position
        ;------------------------------------------------------
        ; Command buffer content
        ;------------------------------------------------------
        bl    @cmdb.refresh         ; Refresh command buffer content
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
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

        ;bl    @cmdb.cmd.clear      ; Clear current command        

        bl    @pane.errline.hide    ; Hide error pane

        bl    @pane.action.colorscheme.load
                                    ; Reload colorscheme
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
        dec   @fb.scrrows           
        ;------------------------------------------------------
        ; Clear error/hint & status line
        ;------------------------------------------------------
!       bl    @hchar
              byte 28,0,32,80*2
              data EOL
        ;------------------------------------------------------
        ; Hide command buffer pane (rest)
        ;------------------------------------------------------
        mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
        clr   @cmdb.visible         ; Hide command buffer pane
        seto  @fb.dirty             ; Redraw framebuffer
        clr   @tv.pane.focus        ; Framebuffer has focus!
        ;------------------------------------------------------
        ; Reload current color scheme
        ;------------------------------------------------------
        seto  @parm1                ; Do not turn screen off while
                                    ; reloading color scheme

        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.hide.exit:        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: pane.cmdb.hide.asm
* Purpose...: Stevie Editor - Command Buffer pane

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
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
* Hiding the command buffer automatically passes pane focus
* to frame buffer. SP2 can destroy tmp0-tmp2 so save on stack.
********|*****|*********************|**************************
pane.cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        ;------------------------------------------------------
        ; Clear error/hint & status line
        ;------------------------------------------------------
        bl    @hchar                ; Destroys tmp0, tmp1,tmp2, tmp3
              byte pane.botrow-6,0,32,80*3
              byte pane.botrow-3,0,32,80*3
              byte pane.botrow-1,0,32,158  ; Do not overwrite AL-symbol
              data EOL              
        ;------------------------------------------------------
        ; Hide command buffer pane (rest)
        ;------------------------------------------------------
        mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
        seto  @cmdb.fb.yxsave       ; Reset (removes "write protection")
        clr   @cmdb.visible         ; Hide command buffer pane
        seto  @fb.dirty             ; Redraw framebuffer
        clr   @tv.pane.focus        ; Framebuffer has focus!
        ;------------------------------------------------------
        ; Reload current color scheme
        ;------------------------------------------------------
        seto  @parm1                ; Do not turn screen off while
                                    ; reloading color scheme
        clr   @parm2                ; Don't skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF

        bl    @pane.cursor.blink    ; Show cursor
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.hide.exit:
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

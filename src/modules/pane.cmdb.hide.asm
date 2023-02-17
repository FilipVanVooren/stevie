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
* none
*--------------------------------------------------------------
* Hiding the command buffer automatically passes pane focus
* to frame buffer.
********|*****|*********************|**************************
pane.cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3
        ;------------------------------------------------------
        ; Hide command buffer pane
        ;------------------------------------------------------
        mov   @fb.scrrows.max,@fb.scrrows
        ;------------------------------------------------------
        ; (1) Adjust frame buffer size if error pane visible
        ;------------------------------------------------------
        mov   @tv.error.visible,tmp0
        jeq   !
        dec   @fb.scrrows
        ;------------------------------------------------------
        ; (2) Clear error/hint & status line
        ;------------------------------------------------------
!       bl    @hchar
              byte pane.botrow-6,0,32,80*3
              byte pane.botrow-3,0,32,80*3
              byte pane.botrow-1,0,32,80*2
              data EOL
        ;------------------------------------------------------
        ; (3) Adjust frame buffer size if ruler visible
        ;------------------------------------------------------
        mov   @tv.ruler.visible,tmp0
        jeq   pane.cmdb.hide.rest
        dec   @fb.scrrows
        ;------------------------------------------------------
        ; (4) Adjust frame buffer size if in master catalog
        ;------------------------------------------------------
        mov   @edb.special.file,tmp0
                                    ; \ 
                                    ; / Check if special file (0=normal file)
                                       
        ci    tmp0,id.special.mastcat 
                                    ; Is master catalog?
        jne   pane.cmdb.hide.rest   ; No, skip adjustment
        
        dec   @fb.scrrows           ; Need space for message
        ;------------------------------------------------------
        ; (5) Hide command buffer pane (rest)
        ;------------------------------------------------------
pane.cmdb.hide.rest:
        mov   @cmdb.fb.yxsave,@wyx  ; Position cursor in framebuffer
        seto  @cmdb.fb.yxsave       ; Reset (removes "write protection")
        clr   @cmdb.visible         ; Hide command buffer pane
        seto  @fb.dirty             ; Redraw framebuffer
        clr   @tv.pane.focus        ; Framebuffer has focus!
        ;------------------------------------------------------
        ; (6) Reload current color scheme
        ;------------------------------------------------------
        seto  @parm1                ; Do not turn screen off while
                                    ; reloading color scheme
        clr   @parm2                ; Don't skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF
        ;------------------------------------------------------
        ; (7) Show cursor again
        ;------------------------------------------------------
        bl    @pane.cursor.blink
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.hide.exit:
        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

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
              byte pane.botrow-1,0,32,80*2
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
                                    ; i  parm1 = Skip screen off if >FFFF
        ;------------------------------------------------------
        ; Show cursor again
        ;------------------------------------------------------
        bl    @pane.cursor.blink
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.hide.exit:        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

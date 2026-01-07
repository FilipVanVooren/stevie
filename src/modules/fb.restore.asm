* FILE......: fb.restore.asm
* Purpose...: Restore frame buffer to normal operation

***************************************************************
* fb.restore
* Restore frame buffer to normal operation (e.g. after command
* has completed)
***************************************************************
*  bl   @fb.restore
*--------------------------------------------------------------
* INPUT
* @parm1 = cursor YX position
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* NONE
********|*****|*********************|**************************
fb.restore:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Refresh framebuffer
        ;------------------------------------------------------
        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; Refresh frame buffer content
                                    ; \ @i  parm1 = Line to start with
        ;------------------------------------------------------
        ; Color marked lines
        ;------------------------------------------------------
        seto  @parm1                ; Force refresh
        bl    @fb.colorlines        ; Colorize frame buffer content
                                    ; \ i  @parm1 = Force refresh if >ffff
                                    ; /
        ;------------------------------------------------------
        ; Color status bottom line
        ;------------------------------------------------------
        mov   @tv.botcolor,@parm1   ; Set normal color
        bl    @pane.colorscheme.botline
                                    ; Set colors for bottom line
                                    ; \ i  @parm1 = Color combination
                                    ; /
        ;------------------------------------------------------
        ; Update status line and show cursor
        ;------------------------------------------------------
        seto  @fb.status.dirty      ; Trigger status line update

        bl    @pane.cursor.blink    ; Show cursor
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.restore.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   @parm1,@wyx           ; Set cursor position
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return

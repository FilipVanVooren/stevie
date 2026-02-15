* FILE......: tv.flash.screen.asm
* Purpose...: Flash screeen for a moment

***************************************************************
* tv.flash.screen
* Flash screen for a moment
***************************************************************
* bl  @tv.flash.screen
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
tv.flash.screen:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Flash screen by changing color scheme for a moment
        ;------------------------------------------------------
        clr   @parm1                     ; Screen off
        clr   @parm2                     ; Marked lines colored
        clr   @parm3                     ; Color everything

        dect  stack
        mov   @tv.colorscheme,*stack     ; Backup color theme 
        mov   @const.13,@tv.colorscheme  ; Set color scheme

        bl    @pane.colorscheme.load     ; Load colorschene
                                         ; \ i  parm1 = Screen on/off
                                         ; | i  parm2 = Marked lines colored
                                         ; / i  parm3 = Color everything

        mov   *stack+,@tv.colorscheme    ; Restore color theme

        seto  @parm1                     ; Screen on
        clr   @parm2                     ; Marked lines colored
        clr   @parm3                     ; Color everything

        bl    @pane.colorscheme.load     ; Load colorschene
                                         ; \ i  parm1 = Screen on/off
                                         ; | i  parm2 = Marked lines colored
                                         ; / i  parm3 = Color everything
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tv.flash.screen.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

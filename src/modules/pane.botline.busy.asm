* FILE......: pane.botline.busy.asm
* Purpose...: Busy indicator functions

***************************************************************
* pane.botline.busy.on
* Turn on busy indicator (colorscheme)
***************************************************************
* bl  @pane.botline.busy.on
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
pane.botline.busy.on:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Show busyline indicator
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,78
              data EOL              ; Clear hint on bottom row

        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.colorscheme.botline
                                    ; Set color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.busy.on.exit:
        mov   *stack+,@parm1        ; Pop @parm1       
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* pane.botline.busy.off
* Turn off busyline indicator (colorscheme)
***************************************************************
* bl  @pane.botline.busy.off
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
pane.botline.busy.off:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Hide busyline indicator
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,78
              data EOL              ; Erase indicator in bottom row

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.colorscheme.botline
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.busy.off.exit:
        mov   *stack+,@parm1        ; Pop @parm1       
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

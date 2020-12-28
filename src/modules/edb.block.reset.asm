***************************************************************
* edb.block.mark.reset
* Reset block markers M1/M2
***************************************************************
*  bl   @edb.block.mark.reset
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* NONE
********|*****|*********************|**************************
edb.block.reset:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Clear markers
        ;------------------------------------------------------
        clr   @edb.block.m1         ; \ Remove markers M1 and M2
        clr   @edb.block.m2         ; /       

        seto  @fb.colorize          ; Set colorize flag                
        seto  @fb.dirty             ; Trigger refresh
        seto  @fb.status.dirty      ; Trigger status lines update
        ;------------------------------------------------------
        ; Reload color scheme
        ;------------------------------------------------------
        seto  @parm1
        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; /
        ;------------------------------------------------------
        ; Remove markers
        ;------------------------------------------------------
        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; /         

        bl    @hchar
              byte 0,52,32,18           ; Remove markers
              byte pane.botrow,0,32,50  ; Remove block shortcuts
              data eol              
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.reset.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        
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
        seto  @edb.block.m1         ; \ Remove markers M1 and M2
        seto  @edb.block.m2         ; /       

        seto  @fb.colorize          ; Set colorize flag                
        seto  @fb.dirty             ; Trigger refresh
        seto  @fb.status.dirty      ; Trigger status lines update
        ;------------------------------------------------------
        ; Reload color scheme
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


        ;------------------------------------------------------
        ; Remove markers
        ;------------------------------------------------------
        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.colorscheme.botline
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; /         

        bl    @hchar
              byte 0,50,32,20           ; Remove markers
              byte pane.botrow,0,32,55  ; Remove block shortcuts
              data eol              
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.reset.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller        

* FILE......: pane.vdpdump.asm
* Purpose...: Dump all panes to VDP

***************************************************************
* pane.vdpdump
* Dump all panes to VDP
***************************************************************
* bl @pane.vdpdump
*--------------------------------------------------------------
* INPUT
* @fb.dirty         = Refresh frame buffer if set
* @fb.status.dirty  = Refresh top/bottom status lines if set
* @fb.colorize      = Colorize range M1/M2 if set
* @cmdb.dirty       = Refresh command buffer pane if set
* @tv.ruler.visible = Show ruler below top status line if set
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.vdpdump:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; ALPHA-Lock key down?
        ;------------------------------------------------------
pane.vdpdump.alpha_lock:        
        coc   @wbit10,config
        jeq   pane.vdpdump.alpha_lock.down
        ;------------------------------------------------------
        ; AlPHA-Lock is up
        ;------------------------------------------------------
        bl    @putat
              byte pane.botrow,78
              data txt.ws4
        jmp   pane.vdpdump.cmdb.check
        ;------------------------------------------------------
        ; AlPHA-Lock is down
        ;------------------------------------------------------
pane.vdpdump.alpha_lock.down:
        bl    @putat      
              byte pane.botrow,78
              data txt.alpha.down       
        ;------------------------------------------------------ 
        ; Command buffer visible ?
        ;------------------------------------------------------
pane.vdpdump.cmdb.check
        mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
        jeq   !                     ; No, skip CMDB pane
        ;-------------------------------------------------------
        ; Draw command buffer pane if dirty
        ;-------------------------------------------------------
pane.vdpdump.cmdb.draw:
        mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
        jeq   pane.vdpdump.exit     ; No, skip update
        ;-------------------------------------------------------
        ; Colorize CMDB pane if "one-time only flag" set?
        ;-------------------------------------------------------
        ci    tmp0,tv.1timeonly
        jne   pane.vdpdump.cmdb.draw.content
        ;-------------------------------------------------------
        ; Colorize the CMDB pane
        ;-------------------------------------------------------
pane.vdpdump.cmdb.draw.colorscheme:        
        dect  stack
        mov   @parm1,*stack         ; Push @parm1
        dect  stack
        mov   @parm2,*stack         ; Push @parm2
        dect  stack
        mov   @parm3,*stack         ; Push @parm3

        seto  @parm1                ; Do not turn screen off 
        seto  @parm2                ; Skip colorzing marked lines
        seto  @parm3                ; Only colorize CMDB pane

        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF                                    
                                    ; | i  @parm3 = Only colorize CMDB pane 
                                    ; /             if >FFFF

        mov   *stack+,@parm3        ; Pop @parm3
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1

        seto  @cmdb.dirty           ; Remove special "one-time only" flag
        ;-------------------------------------------------------
        ; Show content in CMDB pane
        ;-------------------------------------------------------
pane.vdpdump.cmdb.draw.content:
        bl    @pane.cmdb.draw       ; Draw CMDB pane  
        clr   @cmdb.dirty           ; Reset CMDB dirty flag
        jmp   pane.vdpdump.exit     ; Exit early
        ;-------------------------------------------------------
        ; Check if frame buffer dirty
        ;-------------------------------------------------------
!       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
        jeq   pane.vdpdump.statlines
                                    ; No, skip update
        mov   @fb.scrrows,@parm1    ; Number of lines to dump
                                    
pane.vdpdump.dump:
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /        
        ;------------------------------------------------------
        ; Color the lines in the framebuffer (TAT)
        ;------------------------------------------------------        
        mov   @fb.colorize,tmp0     ; Check if colorization necessary
        jeq   pane.vdpdump.dumped   ; Skip if flag reset

        bl    @fb.colorlines        ; Colorize lines M1/M2
        ;-------------------------------------------------------
        ; Finished with frame buffer
        ;-------------------------------------------------------
pane.vdpdump.dumped:        
        clr   @fb.dirty             ; Reset framebuffer dirty flag
        seto  @fb.status.dirty      ; Do trigger status lines update
        ;-------------------------------------------------------
        ; Refresh top and bottom line
        ;-------------------------------------------------------
pane.vdpdump.statlines:
        mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
        jeq   pane.vdpdump.exit     ; No, skip update

        bl    @pane.topline         ; Draw top line
        bl    @pane.botline         ; Draw bottom line
        clr   @fb.status.dirty      ; Reset status lines dirty flag
        ;------------------------------------------------------
        ; Show ruler with tab positions
        ;------------------------------------------------------
        mov   @tv.ruler.visible,tmp0 
                                    ; Should ruler be visible?
        jeq   pane.vdpdump.exit     ; No, so exit

        bl    @cpym2v              
              data vdp.fb.toprow.sit
              data fb.ruler.sit 
              data 80               ; Show ruler
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
pane.vdpdump.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
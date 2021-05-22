* FILE......: task.vdp.panes.asm
* Purpose...: Stevie Editor - VDP draw editor panes

***************************************************************
* Task - VDP draw editor panes (frame buffer, CMDB, status line)
********|*****|*********************|**************************
task.vdp.panes:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; ALPHA-Lock key down?
        ;------------------------------------------------------
task.vdp.panes.alpha_lock:        
        coc   @wbit10,config
        jeq   task.vdp.panes.alpha_lock.down
        ;------------------------------------------------------
        ; AlPHA-Lock is up
        ;------------------------------------------------------
        bl    @putat
              byte pane.botrow,78
              data txt.ws4
        jmp   task.vdp.panes.cmdb.check
        ;------------------------------------------------------
        ; AlPHA-Lock is down
        ;------------------------------------------------------
task.vdp.panes.alpha_lock.down:
        bl    @putat      
              byte pane.botrow,78
              data txt.alpha.down       
        ;------------------------------------------------------ 
        ; Command buffer visible ?
        ;------------------------------------------------------
task.vdp.panes.cmdb.check
        mov   @cmdb.visible,tmp0    ; CMDB pane visible ?
        jeq   !                     ; No, skip CMDB pane
        ;-------------------------------------------------------
        ; Draw command buffer pane if dirty
        ;-------------------------------------------------------
task.vdp.panes.cmdb.draw:
        mov   @cmdb.dirty,tmp0      ; Command buffer dirty?
        jeq   task.vdp.panes.exit   ; No, skip update

        bl    @pane.cmdb.draw       ; Draw CMDB pane  
        clr   @cmdb.dirty           ; Reset CMDB dirty flag
        jmp   task.vdp.panes.exit   ; Exit early
        ;-------------------------------------------------------
        ; Check if frame buffer dirty
        ;-------------------------------------------------------
!       mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
        jeq   task.vdp.panes.statlines
                                    ; No, skip update
        mov   @fb.scrrows,@parm1    ; Number of lines to dump
                                    
task.vdp.panes.dump:
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /        
        ;------------------------------------------------------
        ; Color the lines in the framebuffer (TAT)
        ;------------------------------------------------------        
        mov   @fb.colorize,tmp0     ; Check if colorization necessary
        jeq   task.vdp.panes.dumped ; Skip if flag reset

        bl    @fb.colorlines        ; Colorize lines M1/M2
        ;-------------------------------------------------------
        ; Finished with frame buffer
        ;-------------------------------------------------------
task.vdp.panes.dumped:        
        clr   @fb.dirty             ; Reset framebuffer dirty flag
        seto  @fb.status.dirty      ; Do trigger status lines update
        ;-------------------------------------------------------
        ; Refresh top and bottom line
        ;-------------------------------------------------------
task.vdp.panes.statlines:
        mov   @fb.status.dirty,tmp0 ; Are status lines dirty?
        jeq   task.vdp.panes.exit   ; No, skip update

        bl    @pane.topline         ; Draw top line
        bl    @pane.botline         ; Draw bottom line
        clr   @fb.status.dirty      ; Reset status lines dirty flag
        ;------------------------------------------------------
        ; Show ruler with tab positions
        ;------------------------------------------------------
        mov   @tv.ruler.visible,tmp0 
                                    ; Should ruler be visible?
        jeq   task.vdp.panes.exit   ; No, so exit

        bl    @cpym2v              
              data vdp.fb.toprow.sit
              data fb.ruler.sit 
              data 80               ; Show ruler
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     @slotok

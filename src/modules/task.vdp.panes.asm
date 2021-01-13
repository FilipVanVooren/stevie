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
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
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
              byte   pane.botrow,79
              data   txt.alpha.up 
        jmp   task.vdp.panes.cmdb.check
        ;------------------------------------------------------
        ; AlPHA-Lock is down
        ;------------------------------------------------------
task.vdp.panes.alpha_lock.down:
        bl    @putat      
              byte   pane.botrow,79
              data   txt.alpha.down       
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
        ;------------------------------------------------------ 
        ; Determine how many rows to dump
        ;------------------------------------------------------
        c     @edb.lines,@fb.scrrows
        jlt   task.vdp.panes.setrows.small
        mov   @fb.scrrows,tmp1      ; Number of lines to dump
        jmp   task.vdp.panes.dump.fb
        ;------------------------------------------------------
        ; Less lines in editor buffer as rows in frame buffer 
        ;------------------------------------------------------
task.vdp.panes.setrows.small:
        mov   @edb.lines,tmp1       ; \ Number of lines to dump
        inc   tmp1                  ; /
        ;------------------------------------------------------
        ; Determine frame buffer area to dump
        ;------------------------------------------------------
task.vdp.panes.dump.fb:
        mov   tmp1,@parm1
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /        
        ;------------------------------------------------------
        ; Color the lines in the framebuffer (TAT)
        ;------------------------------------------------------        
        mov   @fb.colorize,tmp0     ; Check if colorization necessary
        jeq   task.vdp.panes.eof    ; Skip if flag reset

        bl    @fb.colorlines        ; Colorize lines M1/M2
        ;-------------------------------------------------------
        ; Draw EOF marker
        ;-------------------------------------------------------
task.vdp.panes.eof:
        mov   @fb.topline,tmp0      ; \
        a     @fb.scrrows,tmp0      ; | Last page in editor buffer?
        c     @edb.lines,tmp0       ; |
                                    ; / 
        jgt   task.vdp.panes.statlines
                                    ; No, so skip drawing EOF maker 


*****WRONG THIS CAN NEVER WORK if edb.lines > scrrows **********
        mov   @edb.lines,tmp0   
        inc   tmp0
****************************************************************        
        ;-------------------------------------------------------
        ; Draw marker 
        ;-------------------------------------------------------
        sla   tmp0,8                ; Move LSB to MSB (Y), X=0
        mov   tmp0,@wyx             ; Set VDP cursor

        bl    @putstr
              data txt.marker       ; Display *EOF*

        bl    @setx   
              data 5                ; Cursor after *EOF* string
        ;-------------------------------------------------------
        ; Clear after EOF marker until bottom status line
        ;-------------------------------------------------------
task.vdp.panes.eof.clear:
        mov   @fb.colsline,tmp0     ; tmp0 = Columns per line

        mov   @wyx,tmp1             ; Get cursor YX
        srl   tmp1,8                ; tmp1 = cursor Y position
        neg   tmp1                  ; tmp1 = -Y position 
        a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows

        mpy   tmp0,tmp1             ; tmp2 = Columns * rows 
        ai    tmp2,-5               ; Adjust offset (because of *EOF* string)

        ci    tmp2,1
        jlt   task.vdp.panes.vdpfill.edge
                                    ; \ Handle edge case where tmp2<.
                                    ; / This can happen when on last row in FB.

        jmp   task.vdp.panes.vdpfill.start

task.vdp.panes.vdpfill.edge:
        li    tmp2,75               ; Assume 75 bytes to fill
        ;-------------------------------------------------------
        ; Get VDP start address for fill
        ;-------------------------------------------------------        
task.vdp.panes.vdpfill.start:
        bl    @yx2pnt               ; Set VDP address in tmp0
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
        ;-------------------------------------------------------
        ; Assert
        ;-------------------------------------------------------
task.vdp.panes.vdpfill.assert:        
        ci    tmp2,vdp.sit.size.80x30
                                    ; Number of bytes to clear is reasonable?
        jle   task.vdp.panes.vdpfill
                                    ; Yes, clear the screen
        ;-------------------------------------------------------
        ; CPU crash
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system   
        ;-------------------------------------------------------
        ; Clear screen in VDP memory
        ;-------------------------------------------------------
task.vdp.panes.vdpfill:
        clr   tmp1                  ; Character to write (null!)
        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = byte to write
                                    ; / i  tmp2 = Number of bytes to write
        ;-------------------------------------------------------
        ; Finished with frame buffer
        ;-------------------------------------------------------
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
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     @slotok

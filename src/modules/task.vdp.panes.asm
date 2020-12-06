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

        mov   @wyx,@fb.yxsave       ; Backup cursor
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
        mov   @fb.yxsave,@wyx       ; Restore cursor
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
        jeq   task.vdp.panes.botline
                                    ; No, skip update

        mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
        ;------------------------------------------------------ 
        ; Determine how many rows to copy 
        ;------------------------------------------------------
        c     @edb.lines,@fb.scrrows
        jlt   task.vdp.panes.setrows.small
        mov   @fb.scrrows,tmp1      ; Lines to copy        
        jmp   task.vdp.panes.copy.fb
        ;------------------------------------------------------
        ; Less lines in editor buffer as rows in frame buffer 
        ;------------------------------------------------------
task.vdp.panes.setrows.small:
        mov   @edb.lines,tmp1       ; Lines to copy
        inc   tmp1
        ;------------------------------------------------------
        ; Determine area to copy
        ;------------------------------------------------------
task.vdp.panes.copy.fb:
        mov   tmp1,@parm1
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /        
        ;------------------------------------------------------
        ; Color the lines in the framebuffer (TAT)
        ;------------------------------------------------------        
        bl    @fb.colorlines        ; Colorize lines M1/M2
        ;-------------------------------------------------------
        ; Draw EOF marker at end-of-file
        ;-------------------------------------------------------
task.vdp.panes.copy.eof:
        c     @edb.lines,@fb.scrrows
                                    ; On last screen page?
        jgt   task.vdp.panes.botline
                                    ; Skip drawing EOF maker 
        mov   @edb.lines,tmp0
        inc   tmp0
        ;-------------------------------------------------------
        ; Do actual drawing of EOF marker 
        ;-------------------------------------------------------
task.vdp.panes.draw_marker:
        sla   tmp0,8                ; Move LSB to MSB (Y), X=0
        mov   tmp0,@wyx             ; Set VDP cursor

        bl    @putstr
              data txt.marker       ; Display *EOF*

        bl    @setx   
              data 5                ; Cursor after *EOF* string
        ;-------------------------------------------------------
        ; Clear rest of screen
        ;-------------------------------------------------------
task.vdp.panes.clear_screen:
        mov   @fb.colsline,tmp0     ; tmp0 = Columns per line

        mov   @wyx,tmp1             ; 
        srl   tmp1,8                ; tmp1 = cursor Y position
        neg   tmp1                  ; tmp1 = -Y position 
        a     @fb.scrrows,tmp1      ; tmp1 = -Y position + fb.scrrows

        mpy   tmp0,tmp1             ; tmp2 = tmp0 * tmp1
        ai    tmp2, -5              ; Adjust offset (because of *EOF* string)

        bl    @yx2pnt               ; Set VDP address in tmp0
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
                                    
        clr   tmp1                  ; Character to write (null!)
        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = byte to write
                                    ; / i  tmp2 = Number of bytes to write

        mov   @fb.yxsave,@wyx       ; Restore cursor postion                                    
        ;-------------------------------------------------------
        ; Refresh top and bottom line
        ;-------------------------------------------------------
task.vdp.panes.botline:
        bl    @pane.topline         ; Draw top line
        bl    @pane.botline         ; Draw bottom line
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11

        b     @slotok

* FILE......: task.vdp.panes.asm
* Purpose...: Stevie Editor - VDP draw editor panes

*//////////////////////////////////////////////////////////////
*        Stevie Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

***************************************************************
* Task - VDP draw editor panes (frame buffer, CMDB, status line)
********|*****|*********************|**************************
task.vdp.panes:
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
        jmp   task.vdp.panes.cmdb.draw
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
        jeq   task.vdp.panes.botline.draw
                                    ; No, skip update

        mov   @wyx,@fb.yxsave       ; Backup VDP cursor position
        ;------------------------------------------------------ 
        ; Determine how many rows to copy 
        ;------------------------------------------------------
        c     @edb.lines,@fb.scrrows
        jlt   task.vdp.panes.setrows.small
        mov   @fb.scrrows,tmp1      ; Lines to copy        
        jmp   task.vdp.panes.copy.framebuffer
        ;------------------------------------------------------
        ; Less lines in editor buffer as rows in frame buffer 
        ;------------------------------------------------------
task.vdp.panes.setrows.small:
        mov   @edb.lines,tmp1       ; Lines to copy
        inc   tmp1
        ;------------------------------------------------------
        ; Determine area to copy
        ;------------------------------------------------------
task.vdp.panes.copy.framebuffer:
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!
        clr   tmp0                  ; VDP target address (1nd line on screen!)
        mov   @fb.top.ptr,tmp1      ; RAM Source address
        ;------------------------------------------------------
        ; Copy memory block
        ;------------------------------------------------------
        ci    tmp2,0                ; Something to copy?
        jeq   task.vdp.panes.copy.eof
                                    ; No, skip copy

        bl    @xpym2v               ; Copy to VDP
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Bytes to copy
        clr   @fb.dirty             ; Reset frame buffer dirty flag
        ;-------------------------------------------------------
        ; Draw EOF marker at end-of-file
        ;-------------------------------------------------------
task.vdp.panes.copy.eof:        
        clr   @fb.dirty             ; Reset frame buffer dirty flag        
        mov   @edb.lines,tmp0
        s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline

        c     @fb.scrrows,tmp0      ; Hide if last line on screen
        jle   task.vdp.panes.botline.draw
                                    ; Skip drawing EOF maker
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
        ai    tmp2, -5              ; Adjust offset (becaise of *EOF* string)

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
        ; Draw status line
        ;-------------------------------------------------------
task.vdp.panes.botline.draw:
        bl    @pane.botline.draw    ; Draw status bottom line
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        b     @slotok

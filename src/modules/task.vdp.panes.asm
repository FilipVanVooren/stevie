* FILE......: task.vdp.panes.asm
* Purpose...: stevie Editor - VDP draw editor panes

*//////////////////////////////////////////////////////////////
*        stevie Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

***************************************************************
* Task - VDP draw editor panes (frame buffer, CMDB, status line)
***************************************************************
task.vdp.panes:
        mov   @fb.dirty,tmp0        ; Is frame buffer dirty?
        jeq   task.vdp.panes.exit   ; No, skip update
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
        bl    @xpym2v               ; Copy to VDP
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Bytes to copy
        clr   @fb.dirty             ; Reset frame buffer dirty flag
        ;-------------------------------------------------------
        ; Draw EOF marker at end-of-file
        ;-------------------------------------------------------
        mov   @edb.lines,tmp0
        s     @fb.topline,tmp0      ; Y = @edb.lines - @fb.topline
        inc   tmp0                  ; Y = Y + 1
        c     @fb.scrrows,tmp0      ; Hide if last line on screen
        jle   task.vdp.panes.draw.cmdb
        ;-------------------------------------------------------
        ; Do actual drawing of EOF marker 
        ;-------------------------------------------------------
task.vdp.panes.draw_marker:
        sla   tmp0,8                ; Move LSB to MSB (Y), X=0
        mov   tmp0,@wyx             ; Set VDP cursor

        bl    @putstr
              data txt.marker       ; Display *EOF*
        ;-------------------------------------------------------
        ; Draw empty line after (and below) EOF marker
        ;-------------------------------------------------------
        bl    @setx   
              data  5               ; Cursor after *EOF* string

        mov   @wyx,tmp0
        srl   tmp0,8                ; Right justify                
        inc   tmp0                  ; One time adjust
        c     @fb.scrrows,tmp0      ; Don't spill on last line on screen
        jeq   !
        li    tmp2,colrow+colrow-5  ; Repeat count for 2 lines
        jmp   task.vdp.panes.draw_marker.empty.line
!       li    tmp2,colrow-5         ; Repeat count for 1 line
        ;-------------------------------------------------------
        ; Draw 1 or 2 empty lines
        ;-------------------------------------------------------
task.vdp.panes.draw_marker.empty.line:
        dec   tmp0                  ; One time adjust
        bl    @yx2pnt               ; Set VDP address in tmp0
        li    tmp1,32               ; Character to write (whitespace)
        bl    @xfilv                ; Fill VDP memory
                                    ; i  tmp0 = VDP destination
                                    ; i  tmp1 = byte to write
                                    ; i  tmp2 = Number of bytes to write
        ;-------------------------------------------------------
        ; Show command buffer
        ;-------------------------------------------------------
task.vdp.panes.draw.cmdb:                
        mov   @cmdb.visible,tmp0     ; Show command buffer?        
        jeq   task.vdp.panes.exit    ; No, skip 
        bl    @pane.cmdb.draw        ; Draw command buffer
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        bl    @pane.botline.draw     ; Draw status bottom line
        b     @slotok

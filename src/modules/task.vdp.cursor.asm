* FILE......: task.vdp.cursor.asm
* Purpose...: Stevie Editor - VDP sprite cursor

***************************************************************
* Task - Update cursor shape (blink)
***************************************************************
task.vdp.cursor:
        inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   task.vdp.cursor.visible
        clr   @ramsat+2              ; Hide cursor
        jmp   task.vdp.cursor.copy.sat
                                     ; Update VDP SAT and exit task
task.vdp.cursor.visible:
        mov   @edb.insmode,tmp0      ; Get Editor buffer insert mode
        jeq   task.vdp.cursor.visible.overwrite_mode
        ;------------------------------------------------------
        ; Cursor in insert mode
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode:
        mov   @tv.pane.focus,tmp0    ; Get pane with focus
        jeq   task.vdp.cursor.visible.insert_mode.fb
                                     ; Framebuffer has focus
        ci    tmp0,pane.focus.cmdb
        jeq   task.vdp.cursor.visible.insert_mode.cmdb
        ;------------------------------------------------------
        ; Editor cursor (insert mode)
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode.fb:        
        clr   tmp0                   ; Cursor FB insert mode
        jmp   task.vdp.cursor.visible.cursorshape
        ;------------------------------------------------------
        ; Command buffer cursor (insert mode)
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode.cmdb:        
        li    tmp0,>0100             ; Cursor CMDB insert mode
        jmp   task.vdp.cursor.visible.cursorshape        
        ;------------------------------------------------------
        ; Cursor in overwrite mode
        ;------------------------------------------------------
task.vdp.cursor.visible.overwrite_mode:
        li    tmp0,>0200             ; Cursor overwrite mode
        ;------------------------------------------------------
        ; Set cursor shape
        ;------------------------------------------------------
task.vdp.cursor.visible.cursorshape:
        movb  tmp0,@tv.curshape      ; Save cursor shape  
        mov   @tv.curshape,@ramsat+2 ; Get cursor shape and color
        ;------------------------------------------------------
        ; Copy SAT
        ;------------------------------------------------------
task.vdp.cursor.copy.sat:        
        bl    @cpym2v                ; Copy sprite SAT to VDP
              data sprsat,ramsat,4   ; \ i  p0 = VDP destination
                                     ; | i  p1 = ROM/RAM source
                                     ; / i  p2 = Number of bytes to write
        ;-------------------------------------------------------
        ; Show status bottom line
        ;-------------------------------------------------------  
        mov   @cmdb.visible,tmp0     ; Check if CMDB pane is visible
        jne   task.vdp.cursor.exit   ; Exit, if visible
        bl    @pane.botline          ; Draw status bottom line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        b     @slotok                ; Exit task
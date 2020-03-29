* FILE......: task.vdp.cursor.asm
* Purpose...: TiVi Editor - VDP sprite cursor

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

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
        clr   tmp0
        jmp   task.vdp.cursor.visible.cursorshape
        ;------------------------------------------------------
        ; Cursor in overwrite mode
        ;------------------------------------------------------
task.vdp.cursor.visible.overwrite_mode:
        li    tmp0,>0200
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
              data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
                                     ; | i  tmp1 = ROM/RAM source
                                     ; / i  tmp2 = Number of bytes to write
        ;-------------------------------------------------------
        ; Show status bottom line
        ;-------------------------------------------------------        
        bl    @pane.botline.draw     ; Draw status bottom line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        b     @slotok                ; Exit task
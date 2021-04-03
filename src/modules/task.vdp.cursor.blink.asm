* FILE......: task.vdp.cursor.blink.asm
* Purpose...: VDP sprite cursor shape

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   task.vdp.cursor.visible
        clr   @ramsat+2             ; Hide cursor
        jmp   task.vdp.cursor.copy.sat
                                    ; Update VDP SAT and exit task
task.vdp.cursor.visible:
        mov   @edb.insmode,tmp0     ; Get Editor buffer insert mode
        jeq   task.vdp.cursor.visible.overwrite_mode
        ;------------------------------------------------------
        ; Cursor in insert mode
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode:
        mov   @tv.pane.focus,tmp0   ; Get pane with focus
        jeq   task.vdp.cursor.visible.insert_mode.fb
                                    ; Framebuffer has focus
        ci    tmp0,pane.focus.cmdb
        jeq   task.vdp.cursor.visible.insert_mode.cmdb
        ;------------------------------------------------------
        ; Editor cursor (insert mode)
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode.fb:        
        clr   tmp0                  ; Cursor FB insert mode
        jmp   task.vdp.cursor.visible.cursorshape
        ;------------------------------------------------------
        ; Command buffer cursor (insert mode)
        ;------------------------------------------------------
task.vdp.cursor.visible.insert_mode.cmdb:        
        li    tmp0,>0100            ; Cursor CMDB insert mode
        jmp   task.vdp.cursor.visible.cursorshape        
        ;------------------------------------------------------
        ; Cursor in overwrite mode
        ;------------------------------------------------------
task.vdp.cursor.visible.overwrite_mode:
        li    tmp0,>0200            ; Cursor overwrite mode
        ;------------------------------------------------------
        ; Set cursor shape
        ;------------------------------------------------------
task.vdp.cursor.visible.cursorshape:
        movb  tmp0,@tv.curshape     ; Save cursor shape  
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;------------------------------------------------------
        ; Copy SAT
        ;------------------------------------------------------
task.vdp.cursor.copy.sat:        
        bl    @cpym2v               ; Copy sprite SAT to VDP
              data sprsat,ramsat,4  ; \ i  p0 = VDP destination
                                    ; | i  p1 = ROM/RAM source
                                    ; / i  p2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task
***************************************************************
* Task - Update cursor shape (blink)
***************************************************************
task.vdp.cursor:
        inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   task.vdp.cursor.visible
        clr   @ramsat+2              ; Hide cursor
        b     @task.sub_copy_ramsat  ; Update VDP SAT and exit task
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
        b     @task.sub_copy_ramsat  ; Update VDP SAT and exit task

* FILE......: task.vdp.panes.asm
* Purpose...: Stevie Editor - VDP draw editor panes

***************************************************************
* Task - VDP draw editor panes (frame buffer, CMDB, status line)
********|*****|*********************|**************************
task.vdp.panes:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Dump panes to VDP memory
        ;------------------------------------------------------
        bl    @pane.vdpdump     
        ;------------------------------------------------------
        ; Exit task
        ;------------------------------------------------------
task.vdp.panes.exit:
        mov   *stack+,r11           ; Pop r11
        b     @slotok

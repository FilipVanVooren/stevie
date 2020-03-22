* FILE......: tasks.vdp.panes.asm
* Purpose...: TiVi Editor - VDP draw editor panes

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

***************************************************************
* Task - Copy SAT to VDP
***************************************************************
task.vdp.copy.sat:
        soc   @wbit0,config          ; Sprite adjustment on
        bl    @yx2px                 ; Calculate pixel position, result in tmp0
        mov   tmp0,@ramsat           ; Set cursor YX
        b     @task.sub_copy_ramsat  ; Update VDP SAT and exit task

* FILE......: cmdb.asm
* Purpose...: TiVi Editor - Command Buffer module

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Command Buffer implementation
*//////////////////////////////////////////////////////////////


***************************************************************
* cmdb.init
* Initialize Command Buffer
***************************************************************
* bl @cmdb.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
***************************************************************
cmdb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        clr   @cmdb.visible         ; Hide command buffer 

        li    tmp0,5
        mov   tmp0,@cmdb.default    ; Set default size
        mov   tmp0,@cmdb.scrrows    ; Set current size
cmdb.init.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @poprt                ; Return to caller





***************************************************************
* cmdb.show
* Show command buffer pane
***************************************************************
* bl @cmdb.show
*--------------------------------------------------------------
* INPUT
* @parm1 = Size (in row)
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
***************************************************************
cmdb.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Show command buffer pane
        ;------------------------------------------------------
        mov   @parm1,@cmdb.scrrows  ; Set pane size

        mov   @fb.scrrows.max,tmp0
        s     @cmdb.scrrows,tmp0
        mov   tmp0,@fb.scrrows      ; Resize framebuffer

        seto  @cmdb.visible         ; Show pane
        seto  @fb.dirty             ; Redraw framebuffer
cmdb.show.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0
        b     @poprt                ; Return to caller



***************************************************************
* cmdb.hide
* Hide command buffer pane
***************************************************************
* bl @cmdb.show
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
***************************************************************
cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Hide command buffer pane
        ;------------------------------------------------------
        mov   @fb.scrrows.max,@fb.scrrows
                                    ; Resize framebuffer

        clr   @cmdb.visible         ; Hide pane
        seto  @fb.dirty             ; Redraw framebuffer
cmdb.hide.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        b     @poprt                ; Return to caller        
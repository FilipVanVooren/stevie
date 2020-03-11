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
********|*****|*********************|**************************
cmdb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,cmdb.top         ; \ Set pointer to command buffer
        mov   tmp0,@cmdb.top.ptr    ; /

        clr   @cmdb.visible         ; Hide command buffer 
        li    tmp0,8
        mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
        mov   tmp0,@cmdb.default    ; Set default command buffer size

        clr   @cmdb.yxtop           ; Screen Y of 1st row in cmdb pane
        clr   @cmdb.lines           ; Number of lines in cmdb buffer
        clr   @cmdb.dirty           ; Command buffer is clean
        ;------------------------------------------------------
        ; Clear command buffer
        ;------------------------------------------------------
        bl    @film
        data  cmdb.top,>00,cmdb.size 
                                    ; Clear it all the way
cmdb.init.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller




***************************************************************
* cmdb.show
* Show command buffer pane
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
********|*****|*********************|**************************
cmdb.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Show command buffer pane
        ;------------------------------------------------------
        mov   @fb.scrrows.max,tmp0
        s     @cmdb.scrrows,tmp0
        mov   tmp0,@fb.scrrows      ; Resize framebuffer
        
        inct  tmp0                  ; Line below cmdb top border line
        sla   tmp0,8                ; LSB to MSB (Y), X=0
        mov   tmp0,@cmdb.yxtop      ; Set command buffer top row

        seto  @cmdb.visible         ; Show pane
        seto  @fb.dirty             ; Redraw framebuffer
cmdb.show.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



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
********|*****|*********************|**************************
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
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* cmdb.refresh
* Refresh command buffer content
***************************************************************
* bl @cmdb.refresh
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
********|*****|*********************|**************************
cmdb.refresh:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Show Command buffer content
        ;------------------------------------------------------
        mov   @wyx,@cmdb.yxsave     ; Save YX position

        mov   @cmdb.yxtop,@wyx
        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.                              

        mov   @cmdb.top.ptr,tmp1    ; Top of command buffer        
        li    tmp2,7*80

        bl    @xpym2v               ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Number of bytes to copy       

        mov   @cmdb.yxsave,@wyx     ; Restore YX position
cmdb.refresh.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


* FILE......: pane.cmdb.show.asm
* Purpose...: Show command buffer pane

***************************************************************
* pane.cmdb.show
* Show command buffer pane
***************************************************************
* bl @pane.cmdb.show
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
pane.cmdb.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Hide character cursor
        ;------------------------------------------------------        
        mov   @wyx,@cmdb.fb.yxsave  ; Save YX position in frame buffer

    .ifeq device.f18a,0
        ; Only do this if cursor is a character. 
        ; Skip when help dialog is displayed.
      
        mov   @cmdb.dialog,tmp0     ; Get dialog ID
        ci    tmp0,id.dialog.help
        jeq   pane.cmdb.show.hidechar.done

        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP write address

        movb  @fb.top(tmp0),tmp1    ; Get character underneath cursor
        srl   tmp1,8                ; Right justify
        
        mov   @tv.ruler.visible,tmp2
        jeq   !                     ; Ruler hidden, skip additional offset
        ai    tmp0,80               ; Offset because of ruler  
!       ai    tmp0,80               ; Offset because of topline

        bl    @xvputb               ; Dump character to VDP
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write (LSB)

pane.cmdb.show.hidechar.done:
        mov   @fb.yxsave,@wyx       ; Restore YX position
     .endif
        ;------------------------------------------------------
        ; Show command buffer pane
        ;------------------------------------------------------
        li    tmp0,pane.botrow
        s     @cmdb.scrrows,tmp0
        mov   tmp0,@fb.scrrows      ; Resize framebuffer
        
        sla   tmp0,8                ; LSB to MSB (Y), X=0
        mov   tmp0,@cmdb.yxtop      ; Set position of command buffer header line

        ai    tmp0,>0100
        mov   tmp0,@cmdb.yxprompt   ; Screen position of prompt in cmdb pane
        inc   tmp0
        mov   tmp0,@cmdb.cursor     ; Screen position of cursor in cmdb pane

        seto  @cmdb.visible         ; Show pane

        li    tmp0,tv.1timeonly     ; \ Set CMDB dirty flag (trigger redraw),
        mov   tmp0,@cmdb.dirty      ; / but colorize CMDB pane only once.



        li    tmp0,pane.focus.cmdb  ; \ CMDB pane has focus
        mov   tmp0,@tv.pane.focus   ; /

        bl    @pane.errline.hide    ; Hide error pane
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.show.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
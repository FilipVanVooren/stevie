* FILE......: pane.utils.asm
* Purpose...: Some utility functions. Shared code for all panes


*//////////////////////////////////////////////////////////////
*              Stevie Editor - Pane utility functions
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.show_hintx
* Show hint message
***************************************************************
* bl  @pane.show_hintx
*--------------------------------------------------------------
* INPUT
* @parm1 = Cursor YX position
* @parm2 = Pointer to Length-prefixed string
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.show_hintx:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;-------------------------------------------------------
        ; Display string
        ;-------------------------------------------------------
        mov   @parm1,@wyx           ; Set cursor
        mov   @parm2,tmp1           ; Get string to display
        bl    @xutst0               ; Display string       
        ;-------------------------------------------------------
        ; Get number of bytes to fill ...
        ;-------------------------------------------------------
        mov   @parm2,tmp0
        movb  *tmp0,tmp0            ; Get length byte of hint
        srl   tmp0,8                ; Right justify
        mov   tmp0,tmp2
        mov   tmp0,tmp3             ; Work copy
        neg   tmp2
        ai    tmp2,80               ; Number of bytes to fill        
        ;-------------------------------------------------------
        ; ... and clear until end of line
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; \ Restore YX position
        a     tmp3,tmp0             ; | Adjust X position to end of string
        mov   tmp0,@wyx             ; / Set cursor

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        li    tmp1,32               ; Byte to fill

        bl    @xfilv                ; Clear line
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.show_hintx.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



***************************************************************
* pane.show_hint
* Show hint message (data parameter version)
***************************************************************
* bl  @pane.show_hint
*     data p1,p2
*--------------------------------------------------------------
* INPUT
* p1 = Cursor YX position
* p2 = Pointer to Length-prefixed string
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
pane.show_hint:
        mov   *r11+,@parm1          ; Get parameter 1
        mov   *r11+,@parm2          ; Get parameter 2
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Display pane hint
        ;-------------------------------------------------------
        bl    @pane.show_hintx      ; Display pane hint
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.show_hint.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
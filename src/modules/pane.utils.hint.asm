* FILE......: pane.utils.asm
* Purpose...: Show hint message in pane

***************************************************************
* pane.show_hintx
* Show hint message
***************************************************************
* bl  @pane.show_hintx
*--------------------------------------------------------------
* INPUT
* @parm1 = Cursor YX position
* @parm2 = Pointer to Length-prefixed string
* @parm3 = Pad length
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
        mov   @parm2,tmp0           ; \
        movb  *tmp0,tmp0            ; | Get length byte of hint
        srl   tmp0,8                ; / MSB to LSB
        ;-------------------------------------------------------
        ; Skip padding if source string longer than pad length
        ;-------------------------------------------------------
        c     tmp0,@parm3           ;  String too long?
        jgt   pane.show_hintx.exit  ;  Yes, exit
        jeq   pane.show_hintx.exit  ;  Yes, exit
        ;-------------------------------------------------------
        ; Prepare for padding
        ;-------------------------------------------------------
        mov   tmp0,tmp3             ; Work copy
        mov   tmp0,tmp2             ; \
        neg   tmp2                  ; | Calc number of bytes 
        a     @parm3,tmp2           ; / to fill
        ;------------------------------------------------------
        ; Assert
        ;------------------------------------------------------
        ci    tmp2,80               ; Pad length bogus?
        jle   !                     ; No, is fine. Continue
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; ... and clear until end of line
        ;-------------------------------------------------------
!       mov   @parm1,tmp0           ; \ Restore YX position
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

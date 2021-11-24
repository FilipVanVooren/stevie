
***************************************************************
* error.display
* Display error message
***************************************************************
* bl  @error.display
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to error message
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
error.display:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Display error message
        ;------------------------------------------------------
        mov   @parm1,@parm2         ; Pane hint to display

        li    tmp0,pane.botrow - 1  ; \
        sla   tmp0,8                ; / Y=bottom row - 1, X=0
        mov   tmp0,@parm1           ; Set parameter

        bl    @pane.show_hintx      ; Display pane hint
                                    ; \ i  parm1 = Pointer to string with hint
                                    ; / i  parm2 = YX position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
error.display.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return      
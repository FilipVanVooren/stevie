* FILE......: pane.errline.asm
* Purpose...: Stevie Editor - Error line pane

***************************************************************
* pane.errline.show
* Show command buffer pane
***************************************************************
* bl @pane.errline.show
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
pane.errline.show:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1

        li    tmp1,>00f6            ; White on dark red
        mov   tmp1,@parm1

        li    tmp1,pane.botrow-1    ; 
        mov   tmp1,@parm2           ; Error line on screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
                                    
        ;------------------------------------------------------
        ; Show error line content
        ;------------------------------------------------------
        bl    @putat                ; Display error message
              byte pane.botrow-1,0
              data tv.error.msg        

        mov   @fb.scrrows.max,tmp0
        dec   tmp0
        mov   tmp0,@fb.scrrows      ; Decrease size of frame buffer

        seto  @tv.error.visible     ; Error line is visible
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.errline.show.exit:        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* pane.errline.hide
* Hide error line
***************************************************************
* bl @pane.errline.hide
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
* Hiding the error line passes pane focus to frame buffer.
********|*****|*********************|**************************
pane.errline.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Hide command buffer pane
        ;------------------------------------------------------
!       bl    @errline.init         ; Clear error line

        mov   @tv.color,tmp0        ; Get colors
        srl   tmp0,8                ; Right aligns
        mov   tmp0,@parm1           ; set foreground/background color        


        li    tmp1,pane.botrow-1    ; 
        mov   tmp1,@parm2           ; Error line on screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.errline.hide.exit:        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: pane.errline.asm
* Purpose...: Utilities for error lines

***************************************************************
* pane.errline.drawcolor
* Draw color on rows in error pane
***************************************************************
* bl @pane.errline.drawcolor
*--------------------------------------------------------------
* INPUT
* @tv.error.rows = Number of rows in error pane
* @parm1         = Color combination
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
pane.errline.drawcolor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Determine 1st row in error pane
        ;-------------------------------------------------------
        li    tmp0,pane.botrow      ; Get rows on screen
        mov   tmp0,tmp1             ; \ Get first row in error pane
        s     @tv.error.rows,tmp1   ; /    
        ;-------------------------------------------------------
        ; Dump colors for row
        ;-------------------------------------------------------
pane.errline.drawcolor.loop:
        mov   tmp1,@parm2           ; Row on physical screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen

        inc   tmp1                  ; Next row
        c     tmp1,tmp0             ; Last row reached?
        jlt   pane.errline.drawcolor.loop
                                    ; Not yet, next iteration
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.errline.drawcolor.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller




***************************************************************
* pane.errline.show
* Show command buffer pane
***************************************************************
* bl @pane.errline.show
*--------------------------------------------------------------
* INPUT
* @tv.error.msg = Error message to display
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

        bl    @pane.errline.drawcolor
                                    ; Draw color on rows in error pane
                                    ; \ i  @tv.error.rows = Number of rows
                                    ; / i  @parm1         = Color combination
        ;------------------------------------------------------
        ; Pad error message up to 160 characters
        ;------------------------------------------------------
        li    tmp0,tv.error.msg
        mov   tmp0,@parm1           ; Get pointer to string
                                    
        li    tmp0,240
        mov   tmp0,@parm2           ; Set requested length
        
        li    tmp0,32
        mov   tmp0,@parm3           ; Set character to fill
        
        li    tmp0,rambuf
        mov   tmp0,@parm4           ; Set pointer to buffer for output string

        bl    @tv.pad.string        ; Pad string to specified length
                                    ; \ i  @parm1 = Pointer to string
                                    ; | i  @parm2 = Requested length
                                    ; | i  @parm3 = Fill character
                                    ; | i  @parm4 = Pointer to buffer with
                                    ; /             output string        
        ;------------------------------------------------------
        ; Show error message
        ;------------------------------------------------------
        bl    @at
              byte pane.botrow-3,0  ; Set cursor

        mov   @outparm1,tmp1        ; \ Display error message
        bl    @xutst0               ; /
        
        mov   @fb.scrrows.max,tmp0  ; \
        s     @tv.error.rows,tmp0   ; | Adjust number of rows in frame buffer
        mov   tmp0,@fb.scrrows      ; / 

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
        ; Get color combination
        ;------------------------------------------------------
        bl    @errpane.init         ; Clear error line string in RAM        

        mov   @cmdb.visible,tmp0
        jeq   pane.errline.hide.fbcolor
        ;------------------------------------------------------
        ; CMDB pane color
        ;------------------------------------------------------
        mov   @tv.cmdb.hcolor,tmp0  ; Get colors of CMDB header line
        jmp   !
        ;------------------------------------------------------
        ; Frame buffer color
        ;------------------------------------------------------
pane.errline.hide.fbcolor:
        mov   @tv.color,tmp0        ; Get colors
        srl   tmp0,8                ; Get rid of status line colors
        ;------------------------------------------------------
        ; Dump colors
        ;------------------------------------------------------      
!       mov   tmp0,@parm1           ; set foreground/background color        

        bl    @pane.errline.drawcolor
                                    ; Draw color on rows in error pane
                                    ; \ i  @tv.error.rows = Number of rows
                                    ; / i  @parm1         = Color combination

        clr   @tv.error.visible     ; Error line no longer visible
        mov   @fb.scrrows.max,@fb.scrrows
                                    ; Set frame buffer to full size again
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.errline.hide.exit:        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

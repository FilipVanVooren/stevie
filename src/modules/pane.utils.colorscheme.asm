* FILE......: pane.utils.colorscheme.asm
* Purpose...: Stevie Editor - Color scheme for panes

***************************************************************
* pane.action.colorschene.cycle
* Cycle through available color scheme
***************************************************************
* bl  @pane.action.colorscheme.cycle
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.action.colorscheme.cycle:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   @tv.colorscheme,tmp0  ; Load color scheme index
        ci    tmp0,tv.colorscheme.entries
                                    ; Last entry reached?
        jlt   !
        li    tmp0,1                ; Reset color scheme index
        jmp   pane.action.colorscheme.switch
!       inc   tmp0
        ;-------------------------------------------------------
        ; Switch to new color scheme
        ;-------------------------------------------------------
pane.action.colorscheme.switch:
        mov   tmp0,@tv.colorscheme  ; Save index of color scheme

        bl    @pane.action.colorscheme.load
                                    ; Load current color scheme
        ;-------------------------------------------------------
        ; Show current color palette message
        ;-------------------------------------------------------  
        mov   @wyx,@waux1           ; Save cursor YX position

        bl    @putnum
              byte 0,61
              data tv.colorscheme,rambuf,>3020

        bl    @putat
              byte 0,52
              data txt.colorscheme  ; Show color palette message

        mov   @waux1,@wyx           ; Restore cursor YX position
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------  
        li    tmp0,12000        
!       dec   tmp0
        jne   -!
        ;-------------------------------------------------------
        ; Setup one shot task for removing message
        ;-------------------------------------------------------  
        li    tmp0,pane.clearmsg.task.callback
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.cycle.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



***************************************************************
* pane.action.colorscheme.load
* Load color scheme
***************************************************************
* bl  @pane.action.colorscheme.load
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into color scheme table
* @parm1          = Skip screen off if >FFFF
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
********|*****|*********************|**************************
pane.action.colorscheme.load:
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
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        dect  stack
        mov   @parm1,*stack         ; Push parm1        
        ;-------------------------------------------------------
        ; Turn screen of
        ;-------------------------------------------------------
        mov   @parm1,tmp0
        ci    tmp0,>ffff            ; Skip flag set?
        jeq   !                     ; Yes, so skip screen off
        bl    @scroff               ; Turn screen off        
        ;-------------------------------------------------------
        ; Get FG/BG colors framebuffer text
        ;-------------------------------------------------------
!       mov   @tv.colorscheme,tmp0  ; Get color scheme index 
        dec   tmp0                  ; Internally work with base 0

        sla   tmp0,3                ; Offset into color scheme data table
        ai    tmp0,tv.colorscheme.table
                                    ; Add base for color scheme data table
        mov   *tmp0+,tmp3           ; Get colors ABCD
        mov   tmp3,@tv.color        ; Save colors ABCD
        ;-------------------------------------------------------
        ; Get and save cursor color
        ;-------------------------------------------------------
        mov   *tmp0,tmp4            ; Get colors EFGH
        andi  tmp4,>00ff            ; Only keep LSB (GH)
        mov   tmp4,@tv.curcolor     ; Save cursor color
        ;-------------------------------------------------------
        ; Get FG/BG colors framebuffer marked text & CMDB pane
        ;-------------------------------------------------------
        mov   *tmp0+,tmp4           ; Get colors EFGH again
        andi  tmp4,>ff00            ; Only keep MSB (EF)
        srl   tmp4,8                ; MSB to LSB

        mov   *tmp0+,tmp0           ; Get colors IJKL

        mov   tmp0,tmp1             ; \ Right align IJ and
        srl   tmp1,8                ; | save to @tv.busycolor
        mov   tmp1,@tv.busycolor    ; / 

        mov   tmp0,tmp1             ; \ Right align KL and
        andi  tmp1,>00ff            ; | save to @tv.markcolor
        mov   tmp1,@tv.markcolor    ; /
                                 
        ;-------------------------------------------------------
        ; Dump colors to VDP register 7 (text mode)
        ;-------------------------------------------------------
        mov   tmp3,tmp1             ; Get work copy
        srl   tmp1,8                ; MSB to LSB (frame buffer colors)
        ori   tmp1,>0700
        mov   tmp1,tmp0
        bl    @putvrx               ; Write VDP register
        ;-------------------------------------------------------
        ; Dump colors for frame buffer pane (TAT)
        ;-------------------------------------------------------
        li    tmp0,vdp.fb.toprow.tat
                                    ; VDP start address (frame buffer area)
        mov   tmp3,tmp1             ; Get work copy of colors ABCD
        srl   tmp1,8                ; MSB to LSB (frame buffer colors)
        li    tmp2,(pane.botrow-1)*80
                                    ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill

        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)
        bl    @fb.colorlines
        ;-------------------------------------------------------
        ; Dump colors for CMDB pane (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.cmdbpane:        
        mov   @cmdb.visible,tmp0
        jeq   pane.action.colorscheme.errpane
                                    ; Skip if CMDB pane is hidden

        li    tmp0,vdp.cmdb.toprow.tat
                                    ; VDP start address (CMDB top line)
        mov   tmp4,tmp1             ; Get work copy fg/bg color
        li    tmp2,5*80             ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Dump colors for error line (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.errpane:        
        mov   @tv.error.visible,tmp0
        jeq   pane.action.colorscheme.statline
                                    ; Skip if error line pane is hidden
                                    
        li    tmp1,>00f6            ; White on dark red
        mov   tmp1,@parm1           ; Pass color combination

        li    tmp1,pane.botrow-1    ; 
        mov   tmp1,@parm2           ; Error line on screen

        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;-------------------------------------------------------
        ; Dump colors for top line and bottom line (TAT)
        ;-------------------------------------------------------
pane.action.colorscheme.statline:                
        mov   @tv.color,tmp1
        andi  tmp1,>00ff            ; Only keep LSB (status line colors)
        mov   tmp1,@parm1           ; Set color combination


        clr   @parm2                ; Top row on screen
        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen

        li    tmp1,pane.botrow
        mov   tmp1,@parm2           ; Bottom row on screen
        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;-------------------------------------------------------        
        ; Dump cursor FG color to sprite table (SAT)
        ;-------------------------------------------------------
pane.action.colorscheme.cursorcolor:
        mov   @tv.curcolor,tmp4     ; Get cursor color        
        sla   tmp4,8                ; Move to MSB
        movb  tmp4,@ramsat+3        ; Update FG color in sprite table (SAT)
        movb  tmp4,@tv.curshape+1   ; Save cursor color                                    
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.load.exit:
        bl    @scron                ; Turn screen on
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
  


***************************************************************
* pane.action.colorscheme.statuslines
* Set color combination for top/bottom status lines
***************************************************************
* bl @pane.action.colorscheme.statuslines
*--------------------------------------------------------------
* INPUT
* @parm1 = Color combination to set
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.action.colorscheme.statlines:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Top line
        ;------------------------------------------------------        
        clr   @parm2                ; First row on screen
        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;------------------------------------------------------
        ; Bottom line
        ;------------------------------------------------------        
        li    tmp0,pane.botrow
        mov   tmp0,@parm2           ; Last row on screen        
        bl    @colors.line.set      ; Load color combination for line
                                    ; \ i  @parm1 = Color combination
                                    ; / i  @parm2 = Row on physical screen
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------                                    
pane.action.colorscheme.statlines.exit:        
        mov   *stack+,tmp0          ; Pop tmp0              
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller          
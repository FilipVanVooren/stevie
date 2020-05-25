* FILE......: pane.utils.asm
* Purpose...: Stevie Editor - Utilities used in panes

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Utilities used in panes
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.action.color.cycle
* Cycle through available color scheme
***************************************************************
* bl  @pane.action.color.cycle
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
        clr   tmp0
        jmp   pane.action.colorscheme.switch
!       inc   tmp0
        ;-------------------------------------------------------
        ; switch to new color scheme
        ;-------------------------------------------------------
pane.action.colorscheme.switch:
        mov   tmp0,@tv.colorscheme  ; Save index of color scheme
        bl    @pane.action.colorscheme.load
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.cycle.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
        




***************************************************************
* pane.action.color.load
* Load color scheme
***************************************************************
* bl  @pane.action.colorscheme.load
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into color scheme table
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
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
        bl    @scroff               ; Turn screen off        
        ;-------------------------------------------------------
        ; Get foreground/background color
        ;-------------------------------------------------------
        mov   @tv.colorscheme,tmp0  ; Get color scheme index 
        sla   tmp0,1                ; Offset into color scheme data table
        ai    tmp0,tv.colorscheme.table
                                    ; Add base for color scheme data table
        mov   *tmp0,tmp3            ; Get fg/bg color
        ;-------------------------------------------------------
        ; Dump cursor FG color to sprite table (SAT)
        ;-------------------------------------------------------
        mov   tmp3,tmp1             ; Get work copy fg/bg color        
        srl   tmp1,4                ; Move nibble to right
        andi  tmp1,>0f00
        movb  tmp1,@ramsat+3        ; Update FG color in sprite table (SAT)
        movb  tmp1,@tv.curshape+1   ; Save cursor color
        ;-------------------------------------------------------
        ; Dump colors to VDP register 7 (text mode)
        ;-------------------------------------------------------
        mov   tmp3,tmp1             ; Get work copy
        srl   tmp1,8                ; MSB to LSB
        ori   tmp1,>0700
        mov   tmp1,tmp0
        bl    @putvrx               ; Write VDP register
        ;-------------------------------------------------------
        ; Dump colors for frame buffer pane (TAT)
        ;-------------------------------------------------------
        li    tmp0,>1800            ; VDP start address (frame buffer area)
        mov   tmp3,tmp1             ; Get work copy fg/bg color
        srl   tmp1,8                ; MSB to LSB
        li    tmp2,29*80            ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Dump colors for bottom status line pane (TAT)
        ;-------------------------------------------------------
        li    tmp0,>2110            ; VDP start address (bottom status line)
        mov   tmp3,tmp1             ; Get work copy fg/bg color
        andi  tmp1,>00ff            ; Only keep LSB
        li    tmp2,80               ; Number of bytes to fill
        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.action.colorscheme.load.exit:
        bl    @scron                ; Turn screen on
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
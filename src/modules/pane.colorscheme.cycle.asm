* FILE......: pane.colorscheme.cycle.asm
* Purpose...: Cycle through available color scheme

***************************************************************
* pane.colorscheme.cycle
* Cycle through available color scheme
***************************************************************
* bl  @pane.colorscheme.cycle
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.colorscheme.cycle:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   @tv.colorscheme,tmp0  ; Load color scheme index
        ci    tmp0,tv.colorscheme.entries
                                    ; Last entry reached?
        jlt   !
        li    tmp0,1                ; Reset color scheme index
        jmp   pane.colorscheme.switch
!       inc   tmp0
        ;-------------------------------------------------------
        ; Switch to new color scheme
        ;-------------------------------------------------------
pane.colorscheme.switch:
        mov   tmp0,@tv.colorscheme  ; Save index of color scheme

        bl    @pane.colorscheme.load
                                    ; Load current color scheme
        ;-------------------------------------------------------
        ; Show current color palette message
        ;-------------------------------------------------------
        mov   @wyx,@waux1           ; Save cursor YX position

        bl    @putnum
              byte 0,62
              data tv.colorscheme,rambuf,>3020

        bl    @putat
              byte 0,52
              data txt.colorscheme  ; Show color palette message

        mov   @waux1,@wyx           ; Restore cursor YX position
        ;-------------------------------------------------------
        ; Delay
        ;-------------------------------------------------------
        li    tmp0,6000
!       dec   tmp0
        jne   -!
        ;-------------------------------------------------------
        ; Setup one shot task for removing message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.colorscheme.cycle.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

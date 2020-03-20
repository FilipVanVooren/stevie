* FILE......: edkey.misc.asm
* Purpose...: Actions for miscelanneous keys


*---------------------------------------------------------------
* Quit TiVi
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit
        


*---------------------------------------------------------------
* Show/Hide command buffer pane
********|*****|*********************|**************************
edkey.action.cmdb.toggle:
        mov   @cmdb.visible,tmp0
        jne   edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; Show pane
        ;-------------------------------------------------------
edkey.action.cmdb.show:        
        bl    @cmdb.show            ; Show command buffer pane
        jmp   edkey.action.cmdb.toggle.exit
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
edkey.action.cmdb.hide:
        bl    @cmdb.hide            ; Hide command buffer pane

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.toggle.exit:
        b     @ed_wait              ; Back to editor main



*---------------------------------------------------------------
* Framebuffer down 1 row
*---------------------------------------------------------------
edkey.action.fbdown:
        inc   @fb.scrrows
        seto  @fb.dirty

        b     *r11  


*---------------------------------------------------------------
* Cycle colors
********|*****|*********************|**************************
edkey.action.color.cycle:
        dect  stack
        mov   r11,*stack            ; Push return address

        mov   @tv.colorscheme,tmp0  ; Load color scheme index
        ci    tmp0,2
        jlt   !
        clr   tmp0
        jmp   edkey.action.color.switch
!       inc   tmp0        
*---------------------------------------------------------------
* Do actual color switch
********|*****|*********************|**************************
edkey.action.color.switch:
        mov   tmp0,@tv.colorscheme  ; Save color scheme index
        sla   tmp0,1                ; Offset into color scheme data table
        ai    tmp0,tv.data.colorscheme
                                    ; Add base for color scheme data table
        movb  *tmp0,tmp1            ; Get foreground / background color
        ;-------------------------------------------------------
        ; Dump cursor FG color to sprite table (SAT)
        ;-------------------------------------------------------
        mov   tmp1,tmp2             ; Get work copy
        srl   tmp2,4                ; Move nibble to right
        andi  tmp2,>0f00
        movb  tmp2,@ramsat+3        ; Update FG color in sprite table (SAT)
        movb  tmp2,@tv.curshape+1   ; Save cursor color
        ;-------------------------------------------------------
        ; Dump color combination to VDP color table
        ;-------------------------------------------------------
        srl   tmp1,8                ; MSB to LSB
        ori   tmp1,>0700
        mov   tmp1,tmp0
        bl    @putvrx
        mov   *stack+,r11           ; Pop R11
        b     @ed_wait              ; Back to editor main

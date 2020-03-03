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
        inv   @cmdb.visible
*       jeq   edkey.action.cmdb.hide
        ;-------------------------------------------------------
        ; Show pane
        ;-------------------------------------------------------
edkey.action.cmdb.show:        
        li    tmp0,5
        mov   tmp0,@parm1           ; Set pane size

        bl    @cmdb.show            ; \ Show command buffer pane
                                    ; | i  parm1 = Size in rows
                                    ; /
        jmp   edkey.action.cmdb.toggle.exit
        ;-------------------------------------------------------
        ; Hide pane
        ;-------------------------------------------------------
edkey.action.cmdb.hide:
        bl    @cmdb.hide             ; Hide command buffer pane

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

        bl    *r11  ; should this not be b *11 ??????


*---------------------------------------------------------------
* Cycle colors
*---------------------------------------------------------------
edkey.action.color.cycle:
        dect  stack
        mov   r11,*stack             ; Push return address

        mov   @tv.colorscheme,tmp0   ; Load color scheme index
        ci    tmp0,2
        jlt   !
        clr   tmp0
        jmp   edkey.action.color.switch
!       inc   tmp0        
*---------------------------------------------------------------
* Do actual color switch
*---------------------------------------------------------------
edkey.action.color.switch
        mov   tmp0,@tv.colorscheme   ; Save color scheme index
        sla   tmp0,1                 ; Offset into color scheme data table
        ai    tmp0,tv.data.colorscheme
                                     ; Add base for color scheme data table
        movb  *tmp0,tmp1             ; Get foreground / background color
        srl   tmp1,8                 ; MSB to LSB
        ;-------------------------------------------------------
        ; Dump color combination to VDP color table
        ;-------------------------------------------------------
        ori   tmp1,>0700
        mov   tmp1,tmp0
        bl    @putvrx
    

        ;li    tmp0,>0fc0             ; Start of VDP color table
        ;li    tmp2,16                ; Number of bytes to fill

        ;bl    @xfilv                 ; Fill VDP memory
        ;                             ; \ i tmp0 = VDP destination
        ;                             ; | i tmp1 = Byte to fill
        ;                            ; / i tmp2 = Number of bytes to fill

        mov   *stack+,r11            ; Pop R11
        b     @ed_wait               ; Back to editor main

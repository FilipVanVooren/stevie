* FILE......: tv.reset.asm
* Purpose...: Reset editor (clear buffers)


***************************************************************
* tv.reset
* Reset editor (clear buffers)
***************************************************************
* bl @tv.reset
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r11
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
tv.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Reset editor
        ;------------------------------------------------------
        bl    @cmdb.init            ; Initialize command buffer
        bl    @edb.init             ; Initialize editor buffer
        bl    @edb.find.init        ; Intitialize search buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer
        bl    @errpane.init         ; Initialize error pane
        clr   @edb.locked           ; Clear editor locked flag
        ;------------------------------------------------------
        ; Remove markers and shortcuts
        ;------------------------------------------------------
        bl    @hchar
              byte 0,50,32,20       ; Remove markers
              byte pane.botrow,0,32,51
              data eol              ; Remove block shortcuts
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.reset.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

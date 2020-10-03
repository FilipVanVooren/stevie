* FILE......: tv.asm
* Purpose...: Stevie Editor - Main editor configuration

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Main editor configuration
*//////////////////////////////////////////////////////////////


***************************************************************
* tv.init
* Initialize editor settings
***************************************************************
* bl @tv.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
***************************************************************
tv.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        clr   @tv.colorscheme       ; Set default color scheme 
        clr   @tv.task.oneshot      ; Reset pointer to oneshot task
        soc   @wbit10,config        ; Assume ALPHA LOCK is down
        clr   @tv.pane.about        ; Do not show about pane/dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.init.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   



***************************************************************
* tv.reset
* Reset editor (clear buffer)
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
***************************************************************
tv.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------        
        ; Reset editor
        ;------------------------------------------------------        
        bl    @cmdb.init            ; Initialize command buffer
        bl    @edb.init             ; Initialize editor buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer
        bl    @errline.init         ; Initialize error line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tv.reset.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller   
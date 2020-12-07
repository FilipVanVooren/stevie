* FILE......: pane.utils.asm
* Purpose...: Some utility functions. Shared code for all panes

***************************************************************
* pane.clearmsg.task.callback
* Remove message
***************************************************************
* Called from one-shot task
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
pane.clearmsg.task.callback:
        dect  stack
        mov   r11,*stack            ; Push return address
      
        mov   @wyx,@fb.yxsave       ; Save cursor

        bl    @hchar
              byte 0,52,32,18
              data EOL              ; Clear message

        mov   @fb.yxsave,@wyx       ; Restore cursor

        clr   @tv.task.oneshot      ; Reset oneshot task        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.clearmsg.task.callback.exit:                
        mov   *stack+,r11           ; Pop R11        
        b     *r11                  ; Return to task

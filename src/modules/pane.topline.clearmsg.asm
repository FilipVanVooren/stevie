* FILE......: pane.topline.clearmsg.asm
* Purpose...: One-shot task for clearing overlay message in top line


***************************************************************
* pane.topline.oneshot.clearmsg
* Remove overlay message in top line
***************************************************************
* Runs as one-shot task in slot 3
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
pane.topline.oneshot.clearmsg:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack        
        mov   @wyx,*stack           ; Push cursor position
        ;-------------------------------------------------------
        ; Clear message
        ;-------------------------------------------------------      
        bl    @hchar
              byte 0,52,32,18
              data EOL              ; Clear message

        clr   @tv.task.oneshot      ; Reset oneshot task        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.topline.oneshot.clearmsg.exit:
        mov   *stack+,@wyx          ; Pop cursor position                
        mov   *stack+,r11           ; Pop R11        
        b     *r11                  ; Return to task

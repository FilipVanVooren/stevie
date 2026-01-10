* FILE......: pane.cursor.blink.asm
* Purpose...: Cursor utility functions for panes


***************************************************************
* pane.cursor.blink
* Blink cursor
***************************************************************
* bl  @pane.cursor.blink
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
pane.cursor.blink:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Hide cursor
        ;-------------------------------------------------------
        bl    @mkslot
              data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
              data eol
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.cursor.blink.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

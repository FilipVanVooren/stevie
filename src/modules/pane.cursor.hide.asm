* FILE......: pane.cursor.hide.asm
* Purpose...: Cursor utility functions for panes

***************************************************************
* pane.cursor.hide
* Hide cursor
***************************************************************
* bl  @pane.cursor.hide
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
pane.cursor.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Hide cursor
        ;-------------------------------------------------------   
        bl    @clslot
              data 1                ; Terminate task.vdp.copy.sat

        bl    @clslot
              data 2                ; Terminate task.vdp.cursor
        ;-------------------------------------------------------        
        ; Exit
        ;-------------------------------------------------------
pane.cursor.hide.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

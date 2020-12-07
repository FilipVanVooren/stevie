* FILE......: pane.utils.cursor.asm
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
        bl    @filv                 ; Clear sprite SAT in VDP RAM
              data sprsat,>00,4     ; \ i  p0 = VDP destination
                                    ; | i  p1 = Byte to write
                                    ; / i  p2 = Number of bytes to write
   
        bl    @clslot
              data 1                ; Terminate task.vdp.copy.sat

        bl    @clslot
              data 2                ; Terminate task.vdp.copy.sat

        ;-------------------------------------------------------        
        ; Exit
        ;-------------------------------------------------------
pane.cursor.hide.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



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
        bl    @filv                 ; Clear sprite SAT in VDP RAM
              data sprsat,>00,4     ; \ i  p0 = VDP destination
                                    ; | i  p1 = Byte to write
                                    ; / i  p2 = Number of bytes to write

        bl    @mkslot
              data >0102,task.vdp.copy.sat ; Task 1 - Update cursor position
              data >020f,task.vdp.cursor   ; Task 2 - Toggle cursor shape
              data eol
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.cursor.blink.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

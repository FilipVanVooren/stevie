* FILE......: pane.cmdb.asm
* Purpose...: stevie Editor - Command Buffer pane

*//////////////////////////////////////////////////////////////
*              stevie Editor - Command Buffer pane
*//////////////////////////////////////////////////////////////

***************************************************************
* pane.cmdb.draw
* Draw stevie Command Buffer
***************************************************************
* bl  @pane.cmdb.draw
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
pane.cmdb.draw:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Draw command buffer
        ;------------------------------------------------------
        bl    @cmdb.refresh          ; Refresh command buffer content

        bl    @vchar
              byte 18,0,4,1          ; Top left corner              
              byte 18,79,5,1         ; Top right corner              
              byte 19,0,6,9          ; Left vertical double line
              byte 19,79,7,9         ; Right vertical double line              
              byte 28,0,8,1          ; Bottom left corner
              byte 28,79,9,1         ; Bottom right corner
              data EOL

        bl    @hchar
              byte 18,1,3,78         ; Horizontal top line
              byte 28,1,3,78         ; Horizontal bottom line
              data EOL              
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.cmdb.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        
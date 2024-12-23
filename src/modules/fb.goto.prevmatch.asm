* FILE......: fb.goto.prevmatch.asm
* Purpose...: Goto previous search match


***************************************************************
* fb.goto.prevmatch
* Refresh frame buffer with next search match
* Align variables in editor buffer to match with that position.
****************************************************************
* bl @fb.goto.prevmatch
*--------------------------------------------------------------
* INPUT
* @parm1  = Line in editor buffer to display as top row (goto)
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fb.goto.prevmatch:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------        
        ; Initialisation
        ;-------------------------------------------------------        
        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.goto.prevmatch.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return                

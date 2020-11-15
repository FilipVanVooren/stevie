* FILE......: edb.line.mark.asm
* Purpose...: Stevie Editor - Mark line for block operation

***************************************************************
* edb.line.mark.m1
* Mark line for block operation
***************************************************************
*  bl   @edb.line.mark
*--------------------------------------------------------------
* INPUT
* @parm1 = Line number
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of line
* @outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.line.mark.m1:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @parm1,@edb.block.m1  ; Set block marker M1
        clr   @outparm2             ; Reset SAMS bank
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.line.mark.m1.exit:
        mov   *stack+,tmp1          ; Pop tmp1                
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

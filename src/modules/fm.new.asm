* FILE......: fm.new.asm
* Purpose...: File Manager - New file in editor buffer

***************************************************************
* fm.new
* New file in editor buffer
***************************************************************
* bl  @fm.new
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.new:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
        bl    @tv.reset             ; Reset editor      
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.new.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller        
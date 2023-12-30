* basic......: dialog.asm
* Purpose....: Dialog initialisation

***************************************************************
* dialog
* Dialog initialisation code
***************************************************************
* bl @dialog
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Copy dialog strings to RAM
        ;-------------------------------------------------------
        bl    @cpym2m
              data txt.hint.memstat,ram.msg1,23

        bl    @cpym2m
              data txt.hint.lineterm,ram.msg2,42
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

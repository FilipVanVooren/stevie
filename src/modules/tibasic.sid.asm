* FILE......: tibasic.sid.asm
* Purpose...: Toggle TI Basic SID



***************************************************************
* tibasic.sid
* Toggle TI Basic SID display
***************************************************************
* bl   @tibasic.sid.toggle
*--------------------------------------------------------------
* INPUT
* none
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
tibasic.sid.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle SID display
        ;------------------------------------------------------
        inv   @tibasic.hidesid      ; Toggle 'Hide SID'
        jeq   tibasic.sid.off       
        li    tmp0,txt.keys.basic2           
        jmp   !
tibasic.sid.off:
        li    tmp0,txt.keys.basic
!       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.sid.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        

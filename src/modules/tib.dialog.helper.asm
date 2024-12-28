* FILE......: tib.dialog.helper.asm
* Purpose...: TI Basic dialog helper functions


***************************************************************
* tibasic.am.toggle
* Toggle TI Basic AutoUnpack
***************************************************************
* bl   @tibasic.am.toggle
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
tibasic.am.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle AutoUnpack display
        ;------------------------------------------------------
        inv   @tib.autounpk         ; Toggle 'AutoUnpack'
        jeq   tibasic.am.off
        li    tmp0,txt.keys.basic2
        jmp   !
tibasic.am.off:
        li    tmp0,txt.keys.basic
!       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.am.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

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
        .pushregs 0                 ; Push return address and registers on stack
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
        .popregs 0                  ; Pop registers and return to caller
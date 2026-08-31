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
        .pushregs 1                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;------------------------------------------------------
        ; Toggle AutoUnpack display
        ;------------------------------------------------------
        inv   @tib.autounpk         ; Toggle 'AutoUnpack'
        jeq   tibasic.am.off
        li    tmp0,txt.keys.basic2
        li    tmp1,col.keys.basic2
        jmp   !
tibasic.am.off:
        li    tmp0,txt.keys.basic
        li    tmp1,col.keys.basic
        
!       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.am.exit:
        .popregs 1                  ; Pop registers and return to caller
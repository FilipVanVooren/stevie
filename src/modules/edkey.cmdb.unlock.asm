* FILE......: edkey.cmdb.unlock.asm
* Purpose...: Unlock editor buffer

*---------------------------------------------------------------
* Unlock the editor buffer
*---------------------------------------------------------------
edkey.action.cmdb.unlock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Unlock
        ;-------------------------------------------------------
        bl    @edb.unlock           ; Unlock editor buffer
        ;-------------------------------------------------------
        ; Close dialog if visible
        ;-------------------------------------------------------
        mov   @cmdb.visible,tmp0
        jeq   edkey.action.cmdb.unlock.exit
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.unlock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11   
        b     @edkey.action.top     ; Goto top of file

* FILE......: edkey.cmdb.unlock.asm
* Purpose...: Unlock editor buffer

*---------------------------------------------------------------
* Unlock the editor buffer
*---------------------------------------------------------------
edkey.action.cmdb.unlock:
        dect  stack
        mov   r11,*stack            ; Save return address
        bl    @edb.unlock           ; Unlock editor buffer
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.unlock.exit:
        mov   *stack+,r11           ; Pop R11   
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
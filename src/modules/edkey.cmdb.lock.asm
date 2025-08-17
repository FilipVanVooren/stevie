* FILE......: edkey.cmdb.lock.asm
* Purpose...: Lock editor buffer

*---------------------------------------------------------------
* Lock the editor buffer
*---------------------------------------------------------------
edkey.action.cmdb.lock:
        dect  stack
        mov   r11,*stack            ; Save return address
        bl    @edb.lock             ; Lock editor buffer
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.lock.exit:
        mov   *stack+,r11           ; Pop R11   
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
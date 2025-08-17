* FILE......: edkey.cmdb.shortcuts.asm
* Purpose...: Actions in shortcuts dialog

*---------------------------------------------------------------
* Toggle editor auto insert mode
*---------------------------------------------------------------
edkey.action.cmdb.autoinsert:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Exit early if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.cmdb.autoinsert.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Toggle auto insert mode
        ;-------------------------------------------------------
        bl    @edb.autoinsert.toggle
                                    ; Toggle Auto-Insert mode
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.autoinsert.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
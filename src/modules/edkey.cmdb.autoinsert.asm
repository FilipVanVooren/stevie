* FILE......: edkey.cmdb.autoinsert.asm
* Purpose...: Toggle auto insert mode

*---------------------------------------------------------------
* Toggle editor auto insert mode
*---------------------------------------------------------------
edkey.action.cmdb.autoinsert:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Exit early if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.cmdb.autoinsert.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Toggle auto insert mode
        ;-------------------------------------------------------
        bl    @tv.autoinsert.toggle ; Toggle Auto-Insert mode
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.autoinsert.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

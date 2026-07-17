* FILE......: edk.cmdb.clock.asm
* Purpose...: Toggle clock display in editor

*---------------------------------------------------------------
* Toggle clock display in editor
*---------------------------------------------------------------
edk.act.cmdb.clock:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Toggle clock display
        ;-------------------------------------------------------
        bl    @tv.clock.toggle      ; Toggle clock display mode
        bl    @cmdb.dialog.close    ; Close dialog    
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.clock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

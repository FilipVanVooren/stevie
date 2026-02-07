* FILE......: edkey.cmdb.clock.asm
* Purpose...: Toggle clock display in editor

*---------------------------------------------------------------
* Toggle clock display in editor
*---------------------------------------------------------------
edkey.action.cmdb.clock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Toggle clock display
        ;-------------------------------------------------------
        bl    @tv.clock.toggle      ; Toggle clock display mode
        bl    @cmdb.dialog.close    ; Close dialog    
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.clock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

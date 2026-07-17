* FILE......: edk.cmdb.linelen.asm
* Purpose...: Actions in shortcuts dialog

*---------------------------------------------------------------
* Toggle editor line length display
*---------------------------------------------------------------
edk.act.cmdb.linelen:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Toggle line length display
        ;-------------------------------------------------------
        bl    @tv.linelen.toggle    ; Toggle Line length display
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.linelen.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
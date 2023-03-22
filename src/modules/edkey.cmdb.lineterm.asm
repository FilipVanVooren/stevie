* FILE......: edkey.cmdb.lineterm.toggle.asm
* Purpose...: Turn line termination character on/off

*---------------------------------------------------------------
* Turn line termination character on/off
********|*****|*********************|**************************
edkey.action.cmdb.lineterm.toggle:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0    
        ;-------------------------------------------------------
        ; Toggle line termination mode
        ;-------------------------------------------------------        
        mov   @edb.lineterm,tmp0    ; Get line termination mode + char
        neg   tmp0                  ; Toggle on/off (MSB is of interest)
        movb  @edb.lineterm+1,@tmp0lb
                                    ; Restore line termination character (LSB)
        mov   tmp0,@edb.lineterm    ; Save variable
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.lineterm.toggle.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

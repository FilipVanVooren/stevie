* FILE......: edkey.cmdb.lock.asm
* Purpose...: Lock editor buffer

*---------------------------------------------------------------
* Lock the editor buffer
*---------------------------------------------------------------
edkey.action.cmdb.lock:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Lock
        ;-------------------------------------------------------
        bl    @edb.lock             ; Lock editor buffer
        ;-------------------------------------------------------
        ; Close dialog if visible
        ;-------------------------------------------------------
        mov   @cmdb.visible,tmp0
        jeq   edkey.action.cmdb.lock.exit
        bl    @cmdb.dialog.close    ; Close dialog        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.lock.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11  
        b     @edkey.action.top     ; Goto top of file

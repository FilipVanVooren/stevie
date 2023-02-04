* FILE......: edkey.cmdb.cfg.mc.asm
* Purpose...: Configure Master Catalog

*---------------------------------------------------------------
* Configure Master Catalog
*---------------------------------------------------------------
edkey.action.cmdb.cfg.mc:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0      
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        li    tmp0,tv.mc.fname      ; \ 
        mov   tmp0,@parm1           ; / Pointer Master Catalog filename buffer

        li    tmp0,txt.done.mc      ; \
        mov   tmp0,@parm2           ; / Message to display when done
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        bl    @cmdb.cfg.fname       ; Set filename
                                    ; \ i  @parm1 = Pointer to 80 bytes buffer
                                    ; / i  @parm2 = Pointer to message      
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.cfg.mc.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.action.top     ; Goto 1st line in editor buffer 

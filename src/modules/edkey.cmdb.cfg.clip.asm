* FILE......: edkey.cmdb.cfg.clip.asm
* Purpose...: Configure clipboard

*---------------------------------------------------------------
* Configure clipboard
*---------------------------------------------------------------
edkey.action.cmdb.cfg.clip:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0      
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        li    tmp0,tv.clip.fname    ; \
        mov   tmp0,@parm1           ; / Pointer to clipboard filename buffer

        li    tmp0,txt.done.clipdev ; \
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
edkey.action.cmdb.cfg.clip.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b    @edkey.action.top      ; Goto 1st line in editor buffer 

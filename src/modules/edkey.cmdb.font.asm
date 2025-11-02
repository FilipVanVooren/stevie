* FILE......: edkey.cmdb.font.asm
* Purpose...: Set specified font

*---------------------------------------------------------------
* Load font
********|*****|*********************|**************************
edkey.action.cmdb.font1:
        clr   tmp0                  ; Load font 1
        jmp   edkey.action.cmdb.font.load
edkey.action.cmdb.font2:
        li    tmp0,1                ; Load font 2
        jmp   edkey.action.cmdb.font.load
        ;-------------------------------------------------------
        ; Load font
        ;-------------------------------------------------------        
edkey.action.cmdb.font.load:
        mov   tmp0,@parm1
        bl    @tv.set.font          ; Set current font (dumps font to VDP)
                                    ; \ i  @parm1       = Font index (0-5)
                                    ; / o  @tv.font.ptr = Pointer to font
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
edkey.action.cmdb.font.exit:        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

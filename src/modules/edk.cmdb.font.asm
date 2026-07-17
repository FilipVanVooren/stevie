* FILE......: edk.cmdb.font.asm
* Purpose...: Set specified font

*---------------------------------------------------------------
* Load font
********|*****|*********************|**************************
edk.act.cmdb.font1:
        clr   tmp0                  ; Load font 1
        jmp   edk.act.cmdb.font.load
edk.act.cmdb.font2:
        li    tmp0,1                ; Load font 2
        jmp   edk.act.cmdb.font.load
        ;-------------------------------------------------------
        ; Load font
        ;-------------------------------------------------------        
edk.act.cmdb.font.load:
        mov   tmp0,@parm1
        bl    @tv.set.font          ; Set current font (dumps font to VDP)
                                    ; \ i  @parm1       = Font index (0-5)
                                    ; / o  @tv.font.ptr = Pointer to font
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
edk.act.cmdb.font.exit:        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

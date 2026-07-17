* FILE......: edk.fb.find.reset.asm
* Purpose...: Reset results of find operation

***************************************************************
* edkey.fb.find.reset
*
* Reset results of find operation
***************************************************************
* b    @edkey.fb.find.reset
*--------------------------------------------------------------
* INPUT
* none
*
* Register usage
* none
********|*****|*********************|**************************
edk.act.find.reset:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Reset search results
        ;-------------------------------------------------------
        bl    @edb.find.init        ; Reset search results
        seto  @fb.dirty             ; Frame buffer dirty        
        seto  @fb.status.dirty      ; Trigger status lines update
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.find.reset.exit:
        mov   *stack+,r11           ; Pop R11    
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main        

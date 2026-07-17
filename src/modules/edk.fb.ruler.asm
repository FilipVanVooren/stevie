* FILE......: edk.fb.ruler.asm
* Purpose...: Actions to toggle ruler on/off

*---------------------------------------------------------------
* Toggle ruler on/off
********|*****|*********************|**************************
edk.act.toggle.ruler:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @wyx,*stack           ; Push cursor YX
        ;-------------------------------------------------------
        ; Toggle ruler visibility
        ;-------------------------------------------------------
        mov   @tv.ruler.visible,tmp0
                                    ; Ruler currently off?
        jeq   edk.act.toggle.ruler.on
                                    ; Yes, turn it on
        ;-------------------------------------------------------
        ; Turn ruler off
        ;------------------------------------------------------- 
edk.act.toggle.ruler.off:
        seto  @fb.dirty             ; Screen refresh necessary        
        clr   @tv.ruler.visible     ; Toggle ruler visibility
        jmp   edk.act.toggle.ruler.fb                                
        ;-------------------------------------------------------
        ; Turn ruler on
        ;-------------------------------------------------------        
edk.act.toggle.ruler.on:        
        mov   @fb.scrrows,tmp0      ; \ Check if on last row in
        dec   tmp0                  ; | frame buffer, if yes 
        c     @fb.row,tmp0          ; | silenty exit without any
                                    ; | action, preventing  
                                    ; / overflow on bottom row.
        jeq   edk.act.toggle.ruler.exit

        seto  @fb.dirty             ; Screen refresh necessary        
        seto  @tv.ruler.visible     ; Set ruler visibility
        bl    @fb.ruler.init        ; Setup ruler in RAM        
        ;-------------------------------------------------------
        ; Update framebuffer pane
        ;-------------------------------------------------------
edk.act.toggle.ruler.fb:
        bl    @pane.cmdb.hide       ; Same actions as when hiding CMDB
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.toggle.ruler.exit: 
        mov   *stack+,@wyx          ; Pop cursor YX       
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.keyscan.hook.debounce; Back to editor main
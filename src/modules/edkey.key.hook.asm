* FILE......: edkey.key.hook.asm
* Purpose...: Keyboard handling (spectra2 user hook)


****************************************************************
* Editor - spectra2 user hook
****************************************************************
edkey.keyscan.hook:
        coc   @wbit11,config        ; ANYKEY pressed ?
        jne   edkey.keyscan.hook.clear_kbbuffer
                                    ; No, clear buffer and exit
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @keycode1,@keycode2   ; Still pressing previous key?
        jne   edkey.keyscan.hook.new      
                                    ; New key pressed
*---------------------------------------------------------------
* Activate auto-repeat ?
*---------------------------------------------------------------
        inc   @keyrptcnt
        mov   @keyrptcnt,tmp0
        ci    tmp0,30
        jlt   edkey.keyscan.hook.bounce   
                                     ; No, do keyboard bounce delay and return
        jmp   edkey.keyscan.hook.autorepeat                                  
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
edkey.keyscan.hook.new:
        clr   @keyrptcnt            ; Reset key-repeat counter
edkey.keyscan.hook.autorepeat:        
        li    tmp0,250              ; \
!       dec   tmp0                  ; | Inline keyboard bounce delay
        jne   -!                    ; /
        mov   @keycode1,@keycode2   ; Save as previous key
        b     @edkey.key.process    ; Process key
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
edkey.keyscan.hook.clear_kbbuffer:
        clr   @keycode1
        clr   @keycode2
        clr   @keyrptcnt
*--------------------------------------------------------------
* Delay to avoid key bouncing
*-------------------------------------------------------------- 
edkey.keyscan.hook.bounce:
        li    tmp0,2000             ; Avoid key bouncing
        ;------------------------------------------------------
        ; Delay loop
        ;------------------------------------------------------
edkey.keyscan.hook.bounce.loop:
        dec   tmp0
        jne   edkey.keyscan.hook.bounce.loop                
        b     @hookok               ; Return


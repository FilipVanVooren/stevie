* FILE......: hook.keyscan.asm
* Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)






****************************************************************
* Editor - spectra2 user hook
****************************************************************
hook.keyscan:
        coc   @wbit11,config        ; ANYKEY pressed ?
        jne   hook.keyscan.clear_kbbuffer
                                    ; No, clear buffer and exit
        mov   @waux1,@keycode1      ; Save current key pressed                                    
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @keycode1,@keycode2   ; Still pressing previous key?
        jne   hook.keyscan.new      ; New key pressed
*---------------------------------------------------------------
* Activate auto-repeat ?
*---------------------------------------------------------------
        inc   @keyrptcnt
        mov   @keyrptcnt,tmp0
        ci    tmp0,30
        jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
        jmp   hook.keyscan.autorepeat
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
hook.keyscan.new:
        clr   @keyrptcnt            ; Reset key-repeat counter
hook.keyscan.autorepeat:        
        li    tmp0,250              ; \
!       dec   tmp0                  ; | Inline keyboard bounce delay
        jne   -!                    ; /
        mov   @keycode1,@keycode2   ; Save as previous key
        b     @edkey.key.process    ; Process key
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
hook.keyscan.clear_kbbuffer:
        clr   @keycode1
        clr   @keycode2
        clr   @keyrptcnt
*--------------------------------------------------------------
* Delay to avoid key bouncing
*-------------------------------------------------------------- 
hook.keyscan.bounce:
        li    tmp0,2000             ; Avoid key bouncing
        ;------------------------------------------------------
        ; Delay loop
        ;------------------------------------------------------
hook.keyscan.bounce.loop:
        dec   tmp0
        jne   hook.keyscan.bounce.loop
        b     @hookok               ; Return


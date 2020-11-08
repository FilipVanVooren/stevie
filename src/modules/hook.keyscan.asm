* FILE......: hook.keyscan.asm
* Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)

*//////////////////////////////////////////////////////////////
*        Stevie Editor - Keyboard handling (spectra2 user hook)
*//////////////////////////////////////////////////////////////

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
        jeq   hook.keyscan.bounce   ; Do keyboard bounce delay and return
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
        li    tmp0,500              ; \
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


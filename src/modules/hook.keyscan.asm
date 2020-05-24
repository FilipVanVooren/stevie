* FILE......: hook.keyscan.asm
* Purpose...: stevie Editor - Keyboard handling (spectra2 user hook)

*//////////////////////////////////////////////////////////////
*        stevie Editor - Keyboard handling (spectra2 user hook)
*//////////////////////////////////////////////////////////////

****************************************************************
* Editor - spectra2 user hook
****************************************************************
hook.keyscan:
        coc   @wbit11,config        ; ANYKEY pressed ?
        jne   hook.keyscan.clear_kbbuffer
                                    ; No, clear buffer and exit
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @waux1,@waux2         ; Still pressing previous key?
        jeq   hook.keyscan.bounce
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
hook.keyscan.newkey:
        mov   @waux1,@waux2         ; Save as previous key
        b     @edkey.key.process    ; Process key
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
hook.keyscan.clear_kbbuffer:
        clr   @waux1
        clr   @waux2
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
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
        b     @hookok               ; Return
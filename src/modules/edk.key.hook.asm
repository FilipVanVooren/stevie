* FILE......: edk.key.hook.asm
* Purpose...: Keyboard handling (spectra2 user hook)


****************************************************************
* Editor - spectra2 user hook
****************************************************************
edkey.keyscan.hook:
        ;-------------------------------------------------------
        ; Abort if stack is leaking garbage
        ;-------------------------------------------------------
        ci    stack,sp2.stktop      ; There shouldn't be anything
                                    ; on the stack anymore.

        jeq   !                     ; ok, continue
        ;-------------------------------------------------------
        ; Assert failed
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; Run once after each frame's KSCAN, including held keys.
        ; TMGR clears the user-hook block at the next VDP frame.
        ;-------------------------------------------------------
!       soc   @wbit6,config         ; Block hook until next frame
        bl    @rom.farjump          ; Repeat state lives in spare ROM bank 8
              data bank8.rom,vec.1,bankid

        mov   @kb.repeat.emit,tmp0  ; New press or repeat due?
        jeq   edkey.keyscan.hook.exit
        li    r11,hookok            ; Returning actions must resume scanning,
                                    ; not re-enter this event after FARJUMP
        b     @edkey.key.process    ; Process key
        ;------------------------------------------------------
        ; Exit keyboard hook
        ;------------------------------------------------------
edkey.keyscan.hook.exit:
        b     @hookok               ; Return
        ;------------------------------------------------------
        ; Keyboard debounce
        ;------------------------------------------------------
edkey.keyscan.hook.debounce  equ  hookok

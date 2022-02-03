* FILE......: edkey.key.hook.asm
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
        ; Check if key pressed
        ;-------------------------------------------------------
!       coc   @wbit11,config        ; ANYKEY pressed ?
        jne   edkey.keyscan.hook.clear
                                    ; No, clear buffer and exit
        ;------------------------------------------------------
        ; Reset flags
        ;------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        szc   @w$0001,@kbflags      ; Remove keyboard buffer cleared flag
        ;------------------------------------------------------
        ; Key pressed
        ;------------------------------------------------------
        mov   @keycode1,@keycode2   ; Save as previous key
        b     @edkey.key.process    ; Process key
        ;------------------------------------------------------
        ; Clear keyboard buffer if no key pressed
        ;------------------------------------------------------
edkey.keyscan.hook.clear:
        mov   @kbflags,tmp0         ; Get keyboard control flags
        coc   @w$0001,tmp0          ; Keyboard buffer already cleared?
        jeq   edkey.keyscan.hook.exit
                                    ; Yes, skip to exit

        clr   @keycode1             ; \
        clr   @keycode2             ; | Clear keyboard buffer and set
        ori   tmp0,kbf.kbclear      ; | keyboard buffer cleared flag
        mov   tmp0,@kbflags         ; /
        ;------------------------------------------------------
        ; Keyboard debounce
        ;------------------------------------------------------
edkey.keyscan.hook.debounce:
        nop                         ; No purpose anymore, but branched to
                                    ; from several subroutines.
                                    ; Needs to be refactored.
        ;------------------------------------------------------
        ; Exit keyboard hook
        ;------------------------------------------------------
edkey.keyscan.hook.exit:
        b     @hookok               ; Return

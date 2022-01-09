* FILE......: edkey.key.hook.asm
* Purpose...: Keyboard handling (spectra2 user hook)


****************************************************************
* Editor - spectra2 user hook
****************************************************************
edkey.keyscan.hook:
        coc   @wbit11,config        ; ANYKEY pressed ?
        jne   edkey.keyscan.hook.clear
                                    ; No, clear buffer and exit
        ;------------------------------------------------------
        ; Identical key pressed ?
        ;------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @keycode1,@keycode2   ; Still pressing previous key?
        jne   edkey.keyscan.hook.new      
                                    ; New key pressed
        ;------------------------------------------------------
        ; Activate auto-repeat ?
        ;------------------------------------------------------
        inc   @keyrptcnt
        mov   @keyrptcnt,tmp0
        ci    tmp0,30
        jlt   edkey.keyscan.hook.debounce   
                                    ; No, do keyboard bounce delay and return
        jmp   edkey.keyscan.hook.autorepeat                                  
        ;------------------------------------------------------
        ; New key pressed
        ;------------------------------------------------------
edkey.keyscan.hook.new:
        clr   @keyrptcnt            ; Reset key-repeat counter
edkey.keyscan.hook.autorepeat:        
        li    tmp0,250              ; \
!       dec   tmp0                  ; | Inline keyboard bounce delay
        jne   -!                    ; /
        mov   @keycode1,@keycode2   ; Save as previous key
        b     @edkey.key.process    ; Process key
        ;------------------------------------------------------
        ; Clear keyboard buffer if no key pressed
        ;------------------------------------------------------
edkey.keyscan.hook.clear:
        clr   @keycode1
        clr   @keycode2
        clr   @keyrptcnt
        jmp   edkey.keyscan.hook.exit
        ;------------------------------------------------------
        ; Keyboard debounce
        ;------------------------------------------------------
edkey.keyscan.hook.debounce:
        li    tmp0,2000             ; Avoid key bouncing
        ;------------------------------------------------------
        ; Debounce loop
        ;------------------------------------------------------
edkey.keyscan.hook.debounce.loop:
        dec   tmp0
        jne   edkey.keyscan.hook.debounce.loop
        ;------------------------------------------------------
        ; Exit keyboard hook
        ;------------------------------------------------------
edkey.keyscan.hook.exit:
        b     @hookok               ; Return


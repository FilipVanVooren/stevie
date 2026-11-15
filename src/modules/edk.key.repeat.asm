* FILE......: edk.key.repeat.asm
* Purpose...: Frame-paced keyboard autorepeat (ROM bank 8)
*
* Called once per VDP frame, after Spectra2's console KSCAN.
* ANYKEY signals new presses; >8375=>ff signals release. Preserve the
* first decoded key while held: RKSCAN resets >83c7 before every scan,
* which can change >8375's translation on a held FCTN/SHIFT/CTRL key.
* The dispatcher arms repeat only for typing and approved actions.
* No Spectra2 changes are needed. State is cleared at Stevie startup.

key.repeat.delay.ntsc  equ  30      ; 500 ms at 60 Hz
key.repeat.delay.pal   equ  25      ; 500 ms at 50 Hz
key.repeat.rate.ntsc   equ  5       ; 12 repeats/second
key.repeat.rate.pal    equ  4       ; 12.5 repeats/second

edkey.key.repeat:
        clr   @kb.repeat.emit
        ; Read physical modifiers. KSCAN's cached byte at >83c7 is
        ; reset by RKSCAN, so it cannot identify held modifiers.
        dect  stack
        mov   r12,*stack
        clr   tmp1                 ; Keyboard column 0
        li    r12,>0024
        ldcr  tmp1,3
        li    r12,>0006
        stcr  tmp2,8
        andi  tmp2,>7000            ; FCTN, SHIFT, CTRL (active low)
        mov   *stack+,r12

        movb  @>8375,tmp0           ; Read actual held key, not cached event
        srl   tmp0,8
        ci    tmp0,>00ff            ; No key held?
        jne   edkey.key.repeat.check
        ;-------------------------------------------------------
        ; Released: forget the key and cancel pending repeat.
        ;-------------------------------------------------------
        szc   @wbit11,config
        clr   @keycode1
        clr   @keycode2
        clr   @kb.repeat.key
        soc   @w$0001,@kbflags
        jmp   edkey.key.repeat.cancel
        ;-------------------------------------------------------
        ; A fresh press (including a quick re-press of the same
        ; key) is immediate. Let KSCAN identify fresh presses.
        ;-------------------------------------------------------
edkey.key.repeat.check:
        coc   @wbit11,config
        jeq   edkey.key.repeat.new
        ;-------------------------------------------------------
        ; Do not carry a held key into another pane/dialog, or
        ; reinterpret it after modifier changes (e.g. CTRL-space).
        ;-------------------------------------------------------
        c     @tv.pane.focus,@kb.repeat.focus
        jne   edkey.key.repeat.cancel
        c     @cmdb.dialog,@kb.repeat.dialog
        jne   edkey.key.repeat.cancel
        c     tmp2,@kb.repeat.mods
        jne   edkey.key.repeat.cancel
        mov   @kb.repeat.allow,tmp1
        jeq   edkey.key.repeat.exit
        dec   @kb.repeat.count
        jne   edkey.key.repeat.exit

        li    tmp1,key.repeat.rate.ntsc
        coc   @wbit2,config         ; Spectra2 PAL flag
        jne   edkey.key.repeat.rate
        li    tmp1,key.repeat.rate.pal
edkey.key.repeat.rate:
        mov   tmp1,@kb.repeat.count
        mov   @kb.repeat.key,tmp0   ; Keep first press's translated code
        jmp   edkey.key.repeat.emit
        ;-------------------------------------------------------
        ; First press: remember context and start the long delay.
        ; Repeat remains off unless the selected handler arms it.
        ;-------------------------------------------------------
edkey.key.repeat.new:
        szc   @wbit11,config
        clr   @kb.repeat.allow
        mov   tmp0,@kb.repeat.key
        mov   @tv.pane.focus,@kb.repeat.focus
        mov   @cmdb.dialog,@kb.repeat.dialog
        mov   tmp2,@kb.repeat.mods

        li    tmp1,key.repeat.delay.ntsc
        coc   @wbit2,config
        jne   edkey.key.repeat.delay
        li    tmp1,key.repeat.delay.pal
edkey.key.repeat.delay:
        mov   tmp1,@kb.repeat.count
edkey.key.repeat.emit:
        mov   tmp0,@keycode1
        mov   tmp0,@keycode2
        szc   @w$0001,@kbflags
        seto  @kb.repeat.emit
edkey.key.repeat.exit:
        b     *r11                  ; Return through ROM trampoline

edkey.key.repeat.cancel:
        clr   @kb.repeat.allow
        clr   @kb.repeat.count
        b     *r11

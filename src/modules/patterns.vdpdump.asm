* FILE......: patterns.vdpdump.asm
* Purpose...: Dump sprite/character patterns to VDP

***************************************************************
* Dump sprite/character patterns to VDP
********|*****|*********************|**************************
vdp.patterns.dump:
        dect  stack
        mov   r11,*stack            ; Push return address
        ;-------------------------------------------------------
        ; Dump sprite patterns from ROM to VDP SDT
        ;-------------------------------------------------------
        bl    @cpym2v
              data sprpdt,cursors,3*8
        ;-------------------------------------------------------
        ; Dump character patterns from ROM to VDP PDT
        ;-------------------------------------------------------
        bl    @cpym2v
              data >1008,patterns,31*8
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
vdp.patterns.dump.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to task
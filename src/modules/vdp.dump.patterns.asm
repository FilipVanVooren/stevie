* FILE......: vdpdump.patterns.asm
* Purpose...: Dump sprite/character patterns to VDP


***************************************************************
* vdpdump.patterns
* Dump Stevie sprite & tile patterns to VDP
***************************************************************
* bl @vdpdump.patterns
*--------------------------------------------------------------
* INPUT
* None
*--------------------------------------------------------------
* OUTPUT
* None
*--------------------------------------------------------------
* REMARK
* None
*--------------------------------------------------------------
* Register usage
* r11
***************************************************************
vdp.dump.patterns:
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
              data >1008,patterns,32*8
                                    ; Start with ASCII >01
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
vdp.dump.patterns.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to task

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
        .ifeq spritecursor,1

        bl    @cpym2v
              data sprpdt + >0410,cursors,3*8
              
        .endif
        ;-------------------------------------------------------
        ; Dump character patterns from ROM to VDP PDT
        ;-------------------------------------------------------
        bl    @cpym2v
              data vdp.pdt.base+8,patterns,30*8
                                    ; Start with ASCII >01
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
vdp.dump.patterns.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to task

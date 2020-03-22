* FILE......: task.vdp.sat.asm
* Purpose...: TiVi Editor - VDP copy SAT

*//////////////////////////////////////////////////////////////
*        TiVi Editor - Tasks implementation
*//////////////////////////////////////////////////////////////

***************************************************************
* Task - Copy Sprite Attribute Table (SAT) to VDP
***************************************************************
task.vdp.copy.sat:
        soc   @wbit0,config          ; Sprite adjustment on
        bl    @yx2px                 ; Calculate pixel position, result in tmp0
        mov   tmp0,@ramsat           ; Set cursor YX
        
        bl    @cpym2v                ; Copy sprite SAT to VDP
              data sprsat,ramsat,4   ; \ i  tmp0 = VDP destination
                                     ; | i  tmp1 = ROM/RAM source
                                     ; / i  tmp2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.copy.sat.exit:
        b     @slotok                ; Exit task
* FILE......: task.vdp.sat.asm
* Purpose...: Stevie Editor - VDP copy SAT

***************************************************************
* Task - Copy Sprite Attribute Table (SAT) to VDP
********|*****|*********************|**************************
task.vdp.copy.sat:
        mov   @tv.pane.focus,tmp0  
        jeq   !                     ; Frame buffer has focus

        ci    tmp0,pane.focus.cmdb
        jeq   task.vdp.copy.sat.cmdb
                                    ; Command buffer has focus
        ;------------------------------------------------------
        ; Assert failed. Invalid value
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Halt system.
        ;------------------------------------------------------
        ; Command buffer has focus, position cursor
        ;------------------------------------------------------        
task.vdp.copy.sat.cmdb:
        mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane        
        ;------------------------------------------------------
        ; Position cursor
        ;------------------------------------------------------
!       soc   @wbit0,config         ; Sprite adjustment on
        bl    @yx2px                ; \ Calculate pixel position
                                    ; | i  @WYX = Cursor YX
                                    ; / o  tmp0 = Pixel YX
        mov   tmp0,@ramsat          ; Set cursor YX
        
        bl    @cpym2v               ; Copy sprite SAT to VDP
              data sprsat,ramsat,4  ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = ROM/RAM source
                                    ; / i  tmp2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.copy.sat.exit:
        b     @slotok               ; Exit task
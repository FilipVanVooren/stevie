* FILE......: task.vdp.cursor.sat.asm
* Purpose...: Copy cursor SAT to VDP

***************************************************************
* Task - Copy Sprite Attribute Table (SAT) to VDP
********|*****|*********************|**************************
task.vdp.copy.sat:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Get pane with focus
        ;------------------------------------------------------
        mov   @tv.pane.focus,tmp0   ; Get pane with focus

        ci    tmp0,pane.focus.fb
        jeq   task.vdp.copy.sat.fb  ; Frame buffer has focus

        ci    tmp0,pane.focus.cmdb
        jeq   task.vdp.copy.sat.cmdb 
                                    ; CMDB buffer has focus
        ;------------------------------------------------------
        ; Assert failed. Invalid value
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Halt system.
        ;------------------------------------------------------
        ; CMDB buffer has focus, position cursor
        ;------------------------------------------------------        
task.vdp.copy.sat.cmdb:
        mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
        soc   @wbit0,config         ; Sprite adjustment on
        bl    @yx2px                ; \ Calculate pixel position
                                    ; | i  @WYX = Cursor YX
                                    ; / o  tmp0 = Pixel YX

        jmp   task.vdp.copy.sat.write
        ;------------------------------------------------------
        ; Frame buffer has focus, position cursor
        ;------------------------------------------------------        
task.vdp.copy.sat.fb:
        soc   @wbit0,config         ; Sprite adjustment on
        bl    @yx2px                ; \ Calculate pixel position
                                    ; | i  @WYX = Cursor YX
                                    ; / o  tmp0 = Pixel YX

        mov   @tv.ruler.visible,@tv.ruler.visible
        jeq   task.vdp.copy.sat.fb.noruler
        ai    tmp0,>1000            ; Adjust VDP cursor because of topline+ruler
        jmp   task.vdp.copy.sat.write
task.vdp.copy.sat.fb.noruler:
        ai    tmp0,>0800            ; Adjust VDP cursor because of topline
        ;------------------------------------------------------
        ; Dump sprite attribute table
        ;------------------------------------------------------
task.vdp.copy.sat.write:
        mov   tmp0,@ramsat          ; Set cursor YX
        ;------------------------------------------------------
        ; Handle column and row indicators
        ;------------------------------------------------------
        mov   @tv.ruler.visible,@tv.ruler.visible
                                    ; Is ruler visible?
        jeq   task.vdp.copy.sat.hide.indicators

        andi  tmp0,>ff00            ; \ Clear X position
        ori   tmp0,240              ; | Line indicator on pixel X 240
        mov   tmp0,@ramsat+4        ; / Set line indicator    <

        mov   @ramsat,tmp0
        andi  tmp0,>00ff            ; \ Clear Y position
        ori   tmp0,>0800            ; | Column indicator on pixel Y 8
        mov   tmp0,@ramsat+8        ; / Set column indicator  v

        jmp   task.vdp.copy.sat.write2
        ;------------------------------------------------------
        ; Do not show column and row indicators
        ;------------------------------------------------------
task.vdp.copy.sat.hide.indicators:        
        clr   tmp1
        movb  tmp1,@ramsat+7        ; Hide line indicator    <
        movb  tmp1,@ramsat+11       ; Hide column indicator  v
        ;------------------------------------------------------
        ; Dump to VDP
        ;------------------------------------------------------
task.vdp.copy.sat.write2:
        bl    @cpym2v               ; Copy sprite SAT to VDP
              data sprsat,ramsat,14 ; \ i  tmp0 = VDP destination
                                    ; | i  tmp1 = ROM/RAM source
                                    ; / i  tmp2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.copy.sat.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task
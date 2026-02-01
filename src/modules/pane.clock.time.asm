* FILE......: pane.clock.time.asm
* Purpose...: Display clock time in pane

***************************************************************
* pane.clock.time
* Display clock time in pane
***************************************************************
* bl  @pane.clock.time
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.clock.time:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2        
        ;------------------------------------------------------
        ; Read date/time from clock device
        ;------------------------------------------------------
        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.14           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return  
        ;------------------------------------------------------
        ; Display time?
        ;------------------------------------------------------
        mov   @cmdb.visible,tmp0    ; Is CMDB pane visible?
        jne   pane.clock.time.exit  ; Yes, skip time display update
        ;------------------------------------------------------
        ; Display time at bottom row
        ;------------------------------------------------------
        mov  @fh.clock.datetime,tmp0 ; Clock initialized?
        jeq  pane.clock.time.exit    ; No, exit early

        bl    @cpym2v                     ; \ Copy time to VDP memory
              data pane.botrow * 80 + 50  ; | i  p1 = Destination VDP address
              data fh.clock.datetime + 13 ; | i  p2 = Source RAM address
              data 5                      ; / i  p3 = Number of bytes to copy
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.clock.time.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

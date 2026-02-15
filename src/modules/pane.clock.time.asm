* FILE......: pane.clock.time.asm
* Purpose...: Display clock time and date in pane

***************************************************************
* pane.clock.time
* Display clock time and date in pane
***************************************************************
* bl  @pane.clock.time
*--------------------------------------------------------------
* INPUT
* @tv.clock.state = Clock status fla
*    >0000 Clock is off. Do not display time/date
*    >994a Clock is on. Only display clock time/date
*    >ffff Clock is on. Read and display clock time/date
*    >dead No clock device found. Do not display time/date
*
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
        ; Is clock on?
        ;------------------------------------------------------
        mov   @tv.clock.state,tmp0   ; Is clock on?
        jeq   pane.clock.time.exit  ; No, exit early
        ;------------------------------------------------------
        ; Read date/time from clock device
        ;------------------------------------------------------
        ci    tmp0,>994A            ; \ Skip reading clock device?
        jeq    !                    ; / Yes

        bl    @rom.farjump          ; \ Trampoline jump to bank
              data bank2.rom        ; | i  p0 = bank address
              data vec.14           ; | i  p1 = Vector with target address
              data bankid           ; / i  p2 = Source ROM bank for return  
        ;------------------------------------------------------
        ; Display time?
        ;------------------------------------------------------
!       seto  @tv.clock.state          ; Set flag to ON state again
        mov  @fh.clock.datetime,tmp0  ; Clock initialized?
        jeq  pane.clock.time.exit     ; No, exit early

        mov   @cmdb.visible,tmp0    ; Is CMDB pane visible?
        jeq   pane.clock.time.only  ; No, show clock time only

        mov   @cmdb.dialog,tmp0     ; Yes, get active CMDB dialog ID
        ci    tmp0,id.dialog.main   ; \
        jlt   pane.clock.time.exit  ; / Skip clock if input dialog active
        ;------------------------------------------------------
        ; Display time only?
        ;------------------------------------------------------
        mov   @cmdb.visible,tmp0    ; Is CMDB pane visible?
        jne   pane.clock.time.date  ; Yes, show date & time
        ;------------------------------------------------------
        ; Display time only at bottom row
        ;------------------------------------------------------
pane.clock.time.only:        
        bl    @cpym2v                     ; \ Display vertical line
              data pane.botrow * 80 + 48  ; | i  p1 = Destination VDP address
              data txt.vtline             ; | i  p2 = Source RAM address
              data 2                      ; / i  p3 = Number of bytes to copy

        bl    @cpym2v                     ; \ Copy time to VDP memory
              data pane.botrow * 80 + 50  ; | i  p1 = Destination VDP address
              data fh.clock.datetime + 13 ; | i  p2 = Source RAM address
              data 5                      ; / i  p3 = Number of bytes to copy

        jmp   pane.clock.time.exit        ; Exit early
        ;------------------------------------------------------
        ; Display date and time at bottom row
        ;------------------------------------------------------
pane.clock.time.date:        
        bl    @cpym2v                     ; \ Display vertical line
              data pane.botrow * 80 + 56  ; | i  p1 = Destination VDP address
              data txt.vtline             ; | i  p2 = Source RAM address
              data 2                      ; / i  p3 = Number of bytes to copy
        ;------------------------------------------------------
        ; Display day of week
        ;------------------------------------------------------   
        mov   @fh.clock.datetime + 2,tmp0 ; Get day of week (0-6)
        srl   tmp0,8                      ; MSB to LSB
        ai    tmp0,-48                    ; Remove ascii offset
        mpy   @const.3,tmp0               ; \ Multiply DOW by 3, result in tmp1
        ai    tmp1,txt.dow                ; / Add base address of DOW string

        li    tmp0,pane.botrow * 80 + 58  ; Destination VDP address
        li    tmp2,3                      ; Number of bytes to copy
        bl    @xpym2v                     ; \ Copy day of week to VDP memory
                                          ; | i  tmp0 = Destination VDP address
                                          ; | i  tmp1 = Source RAM address
                                          ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; Display date
        ;------------------------------------------------------ 
        bl    @cpym2v                     ; \ Copy date to VDP memory
              data pane.botrow * 80 + 62  ; | i  p1 = Destination VDP address
              data fh.clock.datetime + 4  ; | i  p2 = Source RAM address
              data 8                      ; / i  p3 = Number of bytes to copy
        ;------------------------------------------------------
        ; Display time
        ;------------------------------------------------------    
        bl    @cpym2v                     ; \ Copy time to VDP memory
              data pane.botrow * 80 + 71  ; | i  p1 = Destination VDP address
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

txt.vtline:
        byte  0,6                   ; Vertical line character
        even

txt.dow:
        text 'SUNMONTUEWEDTHUFRISAT'
        even

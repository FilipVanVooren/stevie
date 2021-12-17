* FILE......: hook.keyscan.asm
* Purpose...: Stevie Editor - Keyboard handling (spectra2 user hook)



***************************************************************
* cru.timer
* Activate CRU timer and wait for timer to finish.
* The idea is to have a loop that takes a constant amount of 
* time, independently of CPU clock rate.
***************************************************************
* bl   @cru.timer
*--------------------------------------------------------------
* INPUT
* tmp0  = 
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, r0, r12
*--------------------------------------------------------------
* REMARKS:
* All credits to Thierry Nouspikels TI-Tech pages
* http://www.unige.ch/medecine/nouspikel/ti99/tms9901.htm#Timer%20mode
*
* Don't look here, look at Thierry's page for proper use of CRU
* timer mode.
********|*****|*********************|**************************
cru.timer:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   r0,*stack             ; Push r0
        dect  stack
        mov   r1,*stack             ; Push r1

        dect  stack
        mov   r12,*stack            ; Push r12
        ;-------------------------------------------------------
        ; Setup timer in TMS9901 CRU
        ;-------------------------------------------------------
        clr   r12                   ; CRU base address of the TMS9901
        sbo   0                     ; Enter timer mode in TMS9901
        li    r1,>3fff              ; \ Load Maximum value into clock register
                                    ; | of the TMS9901 timer. It takes roughly
                                    ; / 21.3 microseconds to decrement to 0.

        sbz   2                     ; Disable VDP interrupts 
        sbz   3                     ; Disable timer interrupts
        ;-------------------------------------------------------
        ; Start timer
        ;-------------------------------------------------------
        sbz   0                     ; Put TMS9901 in I/O mode again.
                                    ; \ This starts the timer by copying the
                                    ; | value in the TMS9901 clock register to 
                                    ; | the decrementer.
                                    ; |
                                    ; | The value in the decrementer then gets
                                    ; | decremented every 64th clock impulse of 
                                    ; | the TMS9901 PHI* input pin. 
                                    ; |
                                    ; | The decremented value is constantly
                                    ; / copied to the TMS9901 read register

        ;-------------------------------------------------------
        ; Timer is running, check the TMS9901 read register 
        ;-------------------------------------------------------
         .......
         ........

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
cru.timer.exit:        
        mov   *stack+,r12           ; Pop R12
        mov   *stack+,r1            ; Pop R1        
        mov   *stack+,r0            ; Pop R0
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


* This routine hooks the timer interrupts
* It expects a delay value in R0
* and a branch vector in R1 (or >0000 to use a forever loop)
TIMEON SOCB @H20,@>83FD        Set timer interrupt flag bit
       MOV  R12,@OLDR12        Preserve caller's R12 
       CLR  R12                CRU base address >0000 
       SBZ  1                  Disable peripheral interrupts 
       SBZ  2                  Disable VDP interrupts 
       SBO  3                  Enable timer interrupts
       MOV  R1,@>83E2          Zero if we want to wait in a forever loop 
       JEQ  EVERLP      
       SETO @>83E2             Flad: we intend to branch elsewhere 
       MOV  R1,@>83EC          Set address where to go
EVERLP SLA  R0,1               Make room for clock bit
       INC  R0                 Set the clock bit to put TMS9901 in clock mode 
       LDCR R1,15              Load the clock bit + the delay 
       SBZ  0                  Back to normal mode: start timer
       MOV  @OLDR12,R12        Restore caller's R12
       B    *R11
* This routines "unhooks" the timer interrupt
TIMOFF SZCB @H20,@>83FD        Clear timer interrupt flag bit 
       MOV  R12,@OLDR12        Preserve caller's R12    
       CLR  R12                CRU base address >0000 
       SBO  1                  Enables peripheral interrupts 
       SBO  2                  Enables VDP interrupts 
       SBZ  3                  Disables timer interrupts
       MOV  @OLDR12,R12        Restore caller's R12
       B    *R11









****************************************************************
* Editor - spectra2 user hook
****************************************************************
hook.keyscan:
        coc   @wbit11,config        ; ANYKEY pressed ?
        jne   hook.keyscan.clear_kbbuffer
                                    ; No, clear buffer and exit
        mov   @waux1,@keycode1      ; Save current key pressed                                    
*---------------------------------------------------------------
* Identical key pressed ?
*---------------------------------------------------------------
        szc   @wbit11,config        ; Reset ANYKEY
        c     @keycode1,@keycode2   ; Still pressing previous key?
        jne   hook.keyscan.new      ; New key pressed
*---------------------------------------------------------------
* Activate auto-repeat ?
*---------------------------------------------------------------
        inc   @keyrptcnt
        mov   @keyrptcnt,tmp0
        ci    tmp0,30
        jlt   hook.keyscan.bounce   ; No, do keyboard bounce delay and return
        jmp   hook.keyscan.autorepeat
*--------------------------------------------------------------
* New key pressed
*--------------------------------------------------------------
hook.keyscan.new:
        clr   @keyrptcnt            ; Reset key-repeat counter
hook.keyscan.autorepeat:        
        li    tmp0,250              ; \
!       dec   tmp0                  ; | Inline keyboard bounce delay
        jne   -!                    ; /
        mov   @keycode1,@keycode2   ; Save as previous key
        b     @edkey.key.process    ; Process key
*--------------------------------------------------------------
* Clear keyboard buffer if no key pressed
*--------------------------------------------------------------
hook.keyscan.clear_kbbuffer:
        clr   @keycode1
        clr   @keycode2
        clr   @keyrptcnt
*--------------------------------------------------------------
* Delay to avoid key bouncing
*-------------------------------------------------------------- 
hook.keyscan.bounce:
        li    tmp0,2000             ; Avoid key bouncing
        ;------------------------------------------------------
        ; Delay loop
        ;------------------------------------------------------
hook.keyscan.bounce.loop:
        dec   tmp0
        jne   hook.keyscan.bounce.loop
        b     @hookok               ; Return


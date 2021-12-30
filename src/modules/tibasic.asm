* FILE......: tibasic.asm
* Purpose...: Run console TI Basic 



***************************************************************
* tibasic
* Run TI Basic session
***************************************************************
* bl   @tibasic
*--------------------------------------------------------------
* INPUT
* @tibasic.session = TI Basic session to start/resume
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1, tmp2, r12
*--------------------------------------------------------------
* Remarks
* tibasic >> b @0070 (GPL interpreter/TI Basic) 
*         >> isr
*         >> tibasic.return
********|*****|*********************|**************************
tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack      
        mov   tmp2,*stack           ; Push tmp2
        dect  stack                 
        mov   r12,*stack            ; Push r12
        ;-------------------------------------------------------
        ; Setup SAMS memory
        ;-------------------------------------------------------
        mov   config,@tv.sp2.conf   ; Backup the SP2 config register

        bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
              data tv.sams.2000     ; \ @i = target address of 8 words table
                                    ; /      that contains SAMS layout

        bl    @scroff               ; Turn off screen

        bl    @mem.sams.set.external
                                    ; Load SAMS page layout (from cart space)
                                    ; before running external program.

        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Copy Stevie 16K VDP memory to RAM buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode (32x24)
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic.32x24    ; Equate selected video mode table
        ;-------------------------------------------------------
        ; Resume existing TI Basic session?
        ;-------------------------------------------------------
        mov   @tibasic.session,tmp0 ; \ 
                                    ; | Store TI Basic session ID in tmp0.
                                    ; | Througout the subroutine tmp0 will
                                    ; | keep this value, even when SAMS
                                    ; | banks are switched.
                                    ; /

        ci    tmp0,1
        jeq   tibasic.init.basic1
        ci    tmp0,2
        jeq   tibasic.init.basic2
        ci    tmp0,3
        jeq   tibasic.init.basic3
        ci    tmp0,4
        jeq   tibasic.init.basic4
        ci    tmp0,5
        jeq   tibasic.init.basic5
        ;-------------------------------------------------------
        ; Assert, should never get here
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; New TI Basic session (part 1)
        ;------------------------------------------------------- 
tibasic.init.basic1:               
        mov   @tibasic1.status,tmp1 ; Resume TI Basic session?
        jgt   tibasic.resume.basic1 ; yes, do resume
        ori   tmp1,1                ; \ 
        mov   tmp1,@tibasic1.status ; / Set resume flag for next run

        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1
        jmp   tibasic.init.part2    ; Continue initialisation

tibasic.init.basic2:
        mov   @tibasic2.status,tmp1 ; Resume TI Basic session?
        jgt   tibasic.resume.basic2 ; yes, do resume
        ori   tmp1,1                ; \ 
        mov   tmp1,@tibasic2.status ; / Set resume flag for next run

        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2
        jmp   tibasic.init.part2    ; Continue initialisation

tibasic.init.basic3:
        mov   @tibasic3.status,tmp1 ; Resume TI Basic session?
        jgt   tibasic.resume.basic3 ; yes, do resume
        ori   tmp1,1                ; \ 
        mov   tmp1,@tibasic3.status ; / Set resume flag for next run

        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3
        jmp   tibasic.init.part2    ; Continue initialisation

tibasic.init.basic4:
        mov   @tibasic4.status,tmp1 ; Resume TI Basic session?
        jgt   tibasic.resume.basic4 ; yes, do resume
        ori   tmp1,1                ; \ 
        mov   tmp1,@tibasic4.status ; / Set resume flag for next run

        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4
        jmp   tibasic.init.part2    ; Continue initialisation

tibasic.init.basic5:
        mov   @tibasic5.status,tmp1 ; Resume TI Basic session?
        jgt   tibasic.resume.basic5 ; yes, do resume
        ori   tmp1,1                ; \ 
        mov   tmp1,@tibasic5.status ; / Set resume flag for next run

        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5
        jmp   tibasic.init.part2    ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session (part 2)
        ;------------------------------------------------------- 
tibasic.init.part2:
        bl    @cpym2m
              data cpu.scrpad.src,cpu.scrpad.tgt,256
                                    ; Initialize scratchpad memory for TI Basic
                                    ; @cpu.scrpad.tgt (SAMS bank) with dump 
                                    ; of OS Monitor scratchpad stored at 
                                    ; @cpu.scrpad.src (ROM bank 7).

        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)

        bl    @filv
              data >0300,>D0,2      ; No sprites

        bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to 
              data cpu.scrpad.moved ; | >ad00, change WP to >ad00 and then 
                                    ; | load TI Basic scratchpad from
                                    ; / address @cpu.scrpad.target

        ; ATTENTION
        ; From here on no more access to any of the SP2 or stevie routines.
        ; We're on unknown territory.

        ;-------------------------------------------------------
        ; Poke some values
        ;------------------------------------------------------- 
        mov   @tibasic.scrpad.83d4,@>83d4
        mov   @tibasic.scrpad.83fa,@>83fa
        mov   @tibasic.scrpad.83fc,@>83fc
        mov   @tibasic.scrpad.83fe,@>83fe
        ;-------------------------------------------------------
        ; Register ISR hook in scratch pad
        ;------------------------------------------------------- 
        lwpi  >8300                 ; Scratchpad in >8300 again        
        li    r1,isr                ; \ 
        mov   r1,@>83c4             ; | >83c4 = Pointer to start address of ISR
                                    ; /

        li    r12,>1e00             ; \ Disable SAMS mapper (transparent mode)
        sbz   1                     ; / 
        ;-------------------------------------------------------
        ; Run TI Basic session in GPL Interpreter
        ;-------------------------------------------------------
        lwpi  >83e0
        li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
        movb  r1,@grmwa             ; \
        swpb  r1                    ; | Set GPL address
        movb  r1,@grmwa             ; / 
        nop
        b     @>70                  ; Start GPL interpreter
        ;-------------------------------------------------------
        ; Resume TI-Basic session 1
        ;------------------------------------------------------- 
tibasic.resume.basic1:
        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1
        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 2
        ;------------------------------------------------------- 
tibasic.resume.basic2:
        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2
        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 3
        ;------------------------------------------------------- 
tibasic.resume.basic3:
        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3
        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 4
        ;------------------------------------------------------- 
tibasic.resume.basic4:
        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4
        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 5
        ;------------------------------------------------------- 
tibasic.resume.basic5:
        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5
        jmp   tibasic.resume.part2  ; Continue resume

        ;-------------------------------------------------------
        ; Resume TI-Basic session (part 2)
        ;------------------------------------------------------- 
tibasic.resume.part2:
        li    tmp1,>8080            ; blank blank
        mov   tmp1,@>b01a           ; row 0, col 28
        mov   tmp1,@>b01c           ; row 0, col 30
        mov   tmp0,tmp1             ; Get TI Basic session ID
        ai    tmp1,>8390            ; Add # prefix and TI Basic char offset
        mov   tmp1,@>b01c           ; row 0, col 30

        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore TI Basic 16K VDP memory from
                                    ; RAM buffer >b000->efff

        bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to 
              data cpu.scrpad.moved ; | >ad00, change WP to >ad00 and then 
                                    ; | load TI Basic scratchpad from
                                    ; / address @cpu.scrpad.target

        ; ATTENTION
        ; From here on no more access to any of the SP2 or stevie routines.
        ; We're on unknown territory.

        ;-------------------------------------------------------
        ; Load legacy SAMS bank layout
        ;-------------------------------------------------------
        lwpi  >8300                  ; Workspace must be in scratchpad again!
        clr   r11

        ;-------------------------------------------------------
        ; Resume TI Basic interpreter
        ;------------------------------------------------------- 
        b     @>0ab8                ; Return from interrupt routine.
                                    ; See TI Intern page 32 (german)

        ;-------------------------------------------------------
        ; Required values for TI Basicscratchpad
        ;-------------------------------------------------------
tibasic.scrpad.83d4:
        data  >e0d5
tibasic.scrpad.83fa:
        data  >9800
tibasic.scrpad.83fc:        
        data  >0108
tibasic.scrpad.83fe:
        data  >8c02        

my.session:
        byte  >80,>83,>91




***************************************************************
* isr
* Interrupt Service Routine in TI Basic
***************************************************************
* Called from console rom at >0ab6
* See TI Intern page 32 (german) for details
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r7, 12
********|*****|*********************|**************************
isr:    
        limi  0                     ; \ Turn off interrupts
                                    ; / Prevent ISR reentry 

        mov   r7,@rambuf            ; Backup R7
        mov   r12,@rambuf+2         ; Backup R12
        ;-------------------------------------------------------
        ; Hotkey pressed?
        ;-------------------------------------------------------
        mov   @>8374,r7             ; Get keyboard scancode
        andi  r7,>00ff              ; LSB only
        ci    r7,>0f                ; Hotkey fctn + '9' pressed?
        jeq   tibasic.return        ; Yes, return to Stevie
        ;-------------------------------------------------------
        ; Return from ISR
        ;-------------------------------------------------------
isr.exit:
        mov   @rambuf+2,r12         ; Restore R12
        mov   @rambuf,r7            ; Restore R7
        b     *r11                  ; Return from ISR        


***************************************************************
* tibasic.return
* Return from TI Basic to Stevie
***************************************************************
* bl   @tibasic.return
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1
*--------------------------------------------------------------
* REMARKS
* Called from ISR code
********|*****|*********************|**************************
tibasic.return:
        li    r12,>1e00             ; \ Enable SAMS mapper again
        sbo   1                     ; | We stil have the SAMS banks layout 
                                    ; / mem.sams.layout.external

        lwpi  cpu.scrpad.moved      ; Activate Stevie workspace that got
                                    ; paged out in tibasic.init

        movb  @w$ffff,@>8375        ; Reset keycode     
 
        bl    @cpym2m
              data >8300,cpu.scrpad.tgt,256
                                    ; Backup TI Basic scratchpad to
                                    ; @cpu.scrpad.tgt (SAMS bank)

        bl    @cpu.scrpad.pgin      ; \ Page in copy of Stevie scratch pad memory 
              data cpu.scrpad.moved ; | and activate workspace at >8300
                                    ; / Destroys registers tmp0-tmp2

        mov   @tv.sp2.conf,config   ; Restore the SP2 config register

        bl    @mute                 ; Mute sound generators              
        ;-------------------------------------------------------
        ; Cleanup after return from TI Basic
        ;-------------------------------------------------------
        bl    @scroff               ; Turn screen off
        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Dump TI Basic 16K VDP memory to ram buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Restore VDP screen with Stevie content
        ;-------------------------------------------------------
tibasic.return.stevie:        
        bl    @mem.sams.set.external   
                                    ; Load SAMS page layout when returning from
                                    ; external program.

        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore Stevie 16K to VDP from RAM buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Restore SAMS memory layout for editor buffer and index
        ;-------------------------------------------------------                                      
        bl    @mem.sams.set.stevie  ; Setup SAMS memory banks for stevie
                                    ; \ For this to work the bank having the
                                    ; | @tv.sams.xxxx variables must already
                                    ; | be active and may not switch to 
                                    ; / another bank.
        ;-------------------------------------------------------
        ; Setup F18a 80x30 mode again
        ;-------------------------------------------------------
        bl    @f18unl               ; Unlock the F18a        
        .ifeq device.f18a,1

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        bl    @vidtab               ; Load video mode table into VDP
              data stevie.80x30     ; Equate selected video mode table

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        bl    @putvr                ; Set VDP TAT base address for position
              data >0360            ; based attributes (>40 * >60 = >1800)

        clr   @parm1                ; Screen off while reloading color scheme
        clr   @parm2                ; Don't skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF                                    
                                    ; | i  @parm3 = Only colorize CMDB pane 
                                    ; /             if >FFFF
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.return.exit:
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return        
* FILE......: tibasic.asm
* Purpose...: Run console TI Basic 

***************************************************************
* tibasic
* Run TI Basic session
***************************************************************
* bl   @tibasic
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1
*--------------------------------------------------------------
* Remarks
* tibasic >> b @0070 (GPL interpreter/TI Basic) >> isr >> tibasic.return
********|*****|*********************|**************************
tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Setup SAMS memory
        ;-------------------------------------------------------
        bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
              data tv.sams.2000     ; \ @i = target address of 8 words table
                                    ; /      that contains SAMS layout


        bl    @scroff               ; Turn off screen

        bl    @sams.layout          
              data mem.sams.external 
                                    ; Load SAMS page layout for calling an
                                    ; external program.

        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Copy Stevie 16K VDP memory to RAM buffer
                                    ; buffer >b000->efff                              

        bl    @sams.layout          
              data mem.sams.tibasic ; Load SAMS page layout for TI Basic
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode (32x24)
        ;-------------------------------------------------------
        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic.32x24    ; Equate selected video mode table
        ;-------------------------------------------------------
        ; Resume existing TI Basic session?
        ;-------------------------------------------------------
        mov   @tibasic.status,@tibasic.status 
                                    ; New TI-Basic session?
        jgt   tibasic.resume        ; No, resume existing session
        ;-------------------------------------------------------
        ; New TI Basic session
        ;------------------------------------------------------- 
tibasic.init:
        bl    @cpym2m
              data cpu.scrpad.src,cpu.scrpad.tgt,256
                                    ; Initialize TI Basic scrpad memory in
                                    ; @cpu.scrpad.tgt (SAMS bank #08) with dump 
                                    ; of OS Monitor scrpad stored at 
                                    ; @cpu.scrpad.src (bank 3).

        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)

        bl    @filv
              data >0300,>D0,2      ; No sprites

        bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to 
              data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
                                    ; / predefined address @cpu.scrpad.target

        clr   r11
        mov   @tibasic.scrpad.83d4,@>83d4
        mov   @tibasic.scrpad.83fa,@>83fa
        mov   @tibasic.scrpad.83fc,@>83fc
        mov   @tibasic.scrpad.83fe,@>83fe
        ;-------------------------------------------------------
        ; Register ISR hook
        ;------------------------------------------------------- 
        li    r1,isr                ; \
        mov   r1,@>83c4             ; | >83c4 = Pointer to start address of ISR
                                    ; /
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
        ; Resume existing TI-Basic session
        ;------------------------------------------------------- 
tibasic.resume:        
        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore TI Basic 16K VDP memory from
                                    ; RAM buffer >b000->efff (SAMS pages #04-07)

        bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes stevie scratchpad to 
              data scrpad.copy      ; | >ad00 and then load TI Basic scrpad from
                                    ; / predefined address @cpu.scrpad.target        

        b     @>0ab8                ; Return from interrupt routine.
                                    ; See TI Intern page 32 (german)
        ;-------------------------------------------------------
        ; Required values for scratchpad
        ;-------------------------------------------------------
tibasic.scrpad.83d4:
        data  >e0d5
tibasic.scrpad.83fa:
        data  >9800
tibasic.scrpad.83fc:        
        data  >0108
tibasic.scrpad.83fe:
        data  >8c02        



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
        lwpi  >ad00                 ; Activate Stevie workspace in core RAM 2

        
        movb  @w$ffff,@>8375        ; Reset keycode     

        bl    @cpym2m
              data >8300,cpu.scrpad.tgt,256
                                    ; Backup TI Basic scratchpad to
                                    ; @cpu.scrpad.tgt (SAMS bank #08)

        bl    @cpu.scrpad.pgin      ; Page in copy of Stevie scratch pad memory 
              data scrpad.copy      ; and activate workspace at >8300

        bl    @mute                 ; Mute sound generators              
        ;-------------------------------------------------------
        ; Cleanup after return from TI Basic
        ;-------------------------------------------------------
        bl    @scroff               ; Turn screen off
        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Dump TI Basic 16K VDP memory to ram buffer
                                    ; >b000->efff

        mov   @tibasic.status,tmp1  ; \                                  
        ori   tmp1,1                ; | Set TI Basic reentry flag
        mov   tmp1,@tibasic.status  ; /


        bl    @sams.layout          
              data mem.sams.external 
                                    ; Load SAMS page layout for returning from
                                    ; external program.

        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore Stevie 16K to VDP from RAM buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Restore SAMS memory layout for Stevie
        ;-------------------------------------------------------
        mov   @tv.sams.b000,tmp0
        li    tmp1,>b000
        bl    @xsams.page.set       ; Set sams page for address >b000

        mov   @tv.sams.c000,tmp0
        li    tmp1,>c000
        bl    @xsams.page.set       ; Set sams page for address >c000

        mov   @tv.sams.d000,tmp0
        li    tmp1,>d000
        bl    @xsams.page.set       ; Set sams page for address >d000

        mov   @tv.sams.e000,tmp0
        li    tmp1,>e000
        bl    @xsams.page.set       ; Set sams page for address >e000 

        mov   @tv.sams.f000,tmp0
        li    tmp1,>f000
        bl    @xsams.page.set       ; Set sams page for address >f000
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
        bl    @pane.action.colorscheme.load
                                    ; Reload color scheme
                                    ; i  parm1 = Skip screen off if >FFFF                      
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.return.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
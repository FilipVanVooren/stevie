* FILE......: run.tibasic.asm
* Purpose...: Run console TI Basic 

***************************************************************
* run.tibasic.asm
* Run console TI Basic
***************************************************************
* bl   @run.tibasic
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS
********|*****|*********************|**************************
run.tibasic:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode (32x30)
        ;-------------------------------------------------------
        bl    @scroff               ; Turn off screen

        bl    @cpyv2m
              data vdp.sit.base,auxbuf.top,vdp.sit.size
                                    ; Dump SIT to auxiliary buffer in RAM

        bl    @f18rst               ; Reset and lock the F18A

        bl    @vidtab               ; Load video mode table into VDP
              data tibasic          ; Equate selected video mode table
        ;-------------------------------------------------------
        ; Setup VDP memory for TI Basic in 32x24 mode
        ;------------------------------------------------------- 
        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)

        bl    @filv
              data >0300,>D0,2      ; No sprites
        ;-------------------------------------------------------
        ; Setup scratchpad memory for TI Basic
        ;------------------------------------------------------- 
        bl    @cpu.scrpad.pgout     ; \ Copy 256 bytes of scratchpad memory to 
              data scrpad.copy      ; | >ad00 and then load TI Basic layout from
                                    ; / predefined address @cpu.scrpad.target
        
        clr   r11
        mov   @run.tibasic.83d4,@>83d4
        mov   @run.tibasic.83fa,@>83fa
        mov   @run.tibasic.83fc,@>83fc
        mov   @run.tibasic.83fe,@>83fe
        ;-------------------------------------------------------
        ; Register our ISR hook
        ;------------------------------------------------------- 
        li    r1,isr                ; \
        mov   r1,@>83c4             ; | >83c4 = Pointer to start address of 
                                    ; /         User Interrupt Routine
        ;-------------------------------------------------------
        ; Run TI Basic in GPL Interpreter
        ;-------------------------------------------------------
        lwpi  >83e0
        li    r1,>216f              ; Entrypoint for GPL TI Basic interpreter
        movb  r1,@grmwa             ; \
        swpb  r1                    ; | Set GPL address
        movb  r1,@grmwa             ; / 
        nop
        b     @>70                  ; Start GPL interpreter
        ;-------------------------------------------------------
        ; Return from TI Basic (got here from the ISR)
        ;-------------------------------------------------------
run.tibasic.return:    
        lwpi  >ad00                 ; Activate Stevie workspace        

        bl    @cpu.scrpad.pgin      ; Page in copy of scratch pad memory and
              data scrpad.copy      ; activate workspace at >8300

        bl    @film
              data rambuf,>00,20    ; Clear crunch buffer              

        bl    @scroff               ; Turn screen off

        bl    @cpym2v
              data vdp.sit.base,auxbuf.top,vdp.sit.size
                                    ; Restore SIT from VDP dump

        bl    @f18unl               ; Unlock the F18a        
        .ifeq device.f18a,1

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        bl    @vidtab               ; Load video mode table into VDP
              data stevie.tx8030    ; Equate selected video mode table

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        BL    @putvr                ; Set VDP TAT base address for position
              data >0360            ; based attributes (>40 * >60 = >1800)        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
run.tibasic.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return



        ;-------------------------------------------------------
        ; Required values for scratchpad
        ;-------------------------------------------------------
run.tibasic.83d4:
        data  >e0d5
run.tibasic.83fa:
        data  >9800
run.tibasic.83fc:        
        data  >0108
run.tibasic.83fe:
        data  >8c02        



***************************************************************
* isr
* Interrupt Service Routine for returning to Stevie
***************************************************************
* Called from monitor user interrupt
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r7
********|*****|*********************|**************************
isr:
        mov   r7,@rambuf+20         ; Backup R7
        ;-------------------------------------------------------
        ; Read TI Basic crunch buffer VDP >320
        ;-------------------------------------------------------
        li    r7,>0320
        swpb  r7                    ; \
        movb  r7,@vdpa              ; | Set VDP read address
        swpb  r7                    ; | inlined @vdra call
        movb  r7,@vdpa              ; /         
        ;-------------------------------------------------------
        ; Copy TI Basic crunch buffer to Stevie ram buffer
        ;-------------------------------------------------------
        li    r7,rambuf
        movb  @vdpr,*r7+            ; Read byte 1
        movb  @vdpr,*r7+            ; Read byte 2
        movb  @vdpr,*r7+            ; Read byte 3
        movb  @vdpr,*r7+            ; Read byte 4
        ;-------------------------------------------------------
        ; Check if 'EXIT' in Stevie ram buffer
        ;-------------------------------------------------------
        c     @rambuf,@data.isr.exit
        jne   isr.exit              ; Skip unless 'EX'
        c     @rambuf+2,@data.isr.exit+2
        jne   isr.exit              ; Skip unless 'IT'
        ;-------------------------------------------------------
        ; Return to Stevie
        ;-------------------------------------------------------
        jmp   run.tibasic.return
        ;-------------------------------------------------------
        ; Return from ISR
        ;-------------------------------------------------------
isr.exit:
        mov   @rambuf+20,r7         ; Restore R7
        b     *r11                  ; Return from ISR
data.isr.exit:
        text  'EXIT'
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
        ; Setup SAMS for TI Basic
        ;-------------------------------------------------------
        bl    @sams.layout.copy     ; Backup Stevie SAMS page layout
              data tv.sams.2000     ; \ @i = target address of 8 words table
                                    ; /      that contains SAMS layout

        bl    @sams.layout          
              data mem.sams.tibasic ; Load SAMS page layout for TI Basic

        bl    @cpyv2m
              data vdp.sit.base,>f000,vdp.sit.size
                                    ; Dump Stevie SIT 80x30 to RAM buffer
                                    ; >f000 (SAMS page #08)
        ;-------------------------------------------------------
        ; Put VDP in TI Basic compatible mode (32x30)
        ;-------------------------------------------------------
        bl    @scroff               ; Turn off screen

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
        lwpi  >ad00                 ; Activate Stevie workspace in core RAM 2

        bl    @cpu.scrpad.pgin      ; Page in copy of scratch pad memory and
              data scrpad.copy      ; activate workspace at >8300

        bl    @scroff               ; Turn screen off
        ;-------------------------------------------------------
        ; Cleanup after return from TI Basic
        ;-------------------------------------------------------
        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Dump TI Basic 16K VDP memory to
                                    ; RAM buffer >b000->ffff (SAMS pages #04-07)

        bl    @film
              data rambuf,>00,20    ; Clear crunch buffer copy in RAM

        bl    @cpym2v
              data vdp.sit.base,>f000,vdp.sit.size
                                    ; Dump SIT to VDP from RAM buffer
                                    ; >f000 (SAMS page #08)                                    
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




; TODO slow down hotkey check, messes up basic keyboard scan.

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
        mov   r12,@rambuf+22        ; Backup R12
        ;-------------------------------------------------------
        ; Hotkey pressed?
        ;-------------------------------------------------------
        mov   @>8374,r7             ; Get keyboard scancode
        andi  r7,>00ff              ; LSB only
        ci    r7,>bb                ; Hotkey ctrl + '/' pressed?
        jeq   run.tibasic.return    ; Yes, return to Stevie
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
isr.crunchbuf:        
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
        jmp   run.tibasic.return    ; Return to Stevie
        ;-------------------------------------------------------
        ; Return from ISR
        ;-------------------------------------------------------
isr.exit:
        mov   @rambuf+22,r12        ; Restore R12
        mov   @rambuf+20,r7         ; Restore R7
        b     *r11                  ; Return from ISR
data.isr.exit:
        text  'EXIT'
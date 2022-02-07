* FILE......: tib.session.asm
* Purpose...: Run TI Basic session


***************************************************************
* tibasic
* Run TI Basic session
***************************************************************
* bl   @tibasic
*--------------------------------------------------------------
* INPUT
* @tib.session = TI Basic session to start/resume
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
*
* Uses scratchpad memory
* >83b4   Hide Flag/ISR counter for triggering SID display.
* >83b6   TI Basic Session ID
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
        ; Keep 'Hide SID' flag for later use
        ;-------------------------------------------------------
        mov   @tib.hidesid,@>83fc   ; \
                                    ; | Store a copy in the Stevie
                                    ; | scratchpad >83fc for later use in
                                    ; / TI Basic scratchpad.
        ;-------------------------------------------------------
        ; Keep TI Basic session ID for later use
        ;-------------------------------------------------------
        mov   @tib.session,tmp0     ; \
                                    ; | Store TI Basic session ID in tmp0.
                                    ; | Througout the subroutine tmp0 will
                                    ; | keep this value, even when SAMS
                                    ; | banks are switched.
                                    ; |
        mov   tmp0,@>83fe           ; | Also store a copy in the Stevie
                                    ; | scratchpad >83fe for later use in
                                    ; / TI Basic scratchpad.
        ;-------------------------------------------------------
        ; Switch for TI Basic session
        ;-------------------------------------------------------
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
        ; New TI Basic session 1
        ;-------------------------------------------------------
tibasic.init.basic1:
        mov   @tib.status1,tmp1     ; Resume TI Basic session?
        jeq   !                     ; No, new session
        b     @tibasic.resume.basic1

!       ori   tmp1,1                ; \
        mov   tmp1,@tib.status1     ; / Set resume flag for next run

        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1

        bl    @cpym2v
              data >06f8,tibasic.patterns,8
                                    ; Copy pattern TI-Basic session ID 1

        jmp   tibasic.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 2
        ;-------------------------------------------------------
tibasic.init.basic2:
        mov   @tib.status2,tmp1     ; Resume TI Basic session?
        jeq   !                     ; No, new session
        b     @tibasic.resume.basic2

!       ori   tmp1,1                ; \
        mov   tmp1,@tib.status2     ; / Set resume flag for next run

        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2

        bl    @cpym2v
              data >06f8,tibasic.patterns+8,8
                                    ; Copy pattern TI-Basic session ID 2

        jmp   tibasic.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 3
        ;-------------------------------------------------------
tibasic.init.basic3:
        mov   @tib.status3,tmp1     ; Resume TI Basic session?
        jgt   tibasic.resume.basic3 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status3     ; / Set resume flag for next run

        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3

        bl    @cpym2v
              data >06f8,tibasic.patterns+16,8
                                    ; Copy pattern TI-Basic session ID 3

        jmp   tibasic.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 4
        ;-------------------------------------------------------
tibasic.init.basic4:
        mov   @tib.status4,tmp1     ; Resume TI Basic session?
        jgt   tibasic.resume.basic4 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status4     ; / Set resume flag for next run

        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4

        bl    @cpym2v
              data >06f8,tibasic.patterns+24,8
                                    ; Copy pattern TI-Basic session ID 4

        jmp   tibasic.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 5
        ;-------------------------------------------------------
tibasic.init.basic5:
        mov   @tib.status5,tmp1     ; Resume TI Basic session?
        jgt   tibasic.resume.basic5 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status5     ; / Set resume flag for next run

        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5

        bl    @cpym2v
              data >06f8,tibasic.patterns+32,8
                                    ; Copy pattern TI-Basic session ID 5

        jmp   tibasic.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session (part 2)
        ;-------------------------------------------------------
tibasic.init.rest:
        bl    @ldfnt
              data >0900,fnopt3     ; Load font (upper & lower case)

        bl    @filv
              data >0300,>D0,2      ; No sprites

        bl    @cpu.scrpad.backup    ; (1) Backup stevie primary scratchpad to
                                    ;     fixed memory address @cpu.scrpad.tgt

        bl    @cpym2m
              data >f000,cpu.scrpad2,256
                                    ; (2) Stevie scratchpad dump cannot stay
                                    ;     there, move to final destination.

        bl    @cpym2m
              data cpu.scrpad.src,cpu.scrpad.tgt,256
                                    ; (3) Copy OS monitor scratchpad dump from
                                    ;     cartridge rom to @cpu.scrpad.tgt

        lwpi  cpu.scrpad2           ; Flip workspace before starting restore
        bl    @cpu.scrpad.restore   ; Restore scratchpad from @cpu.scrpad.tgt
        lwpi  cpu.scrpad1           ; Flip workspace to scratchpad again

        ; ATTENTION
        ; From here on no more access to any of the SP2 or stevie routines.
        ; We're on unknown territory.

        mov   @cpu.scrpad2+252,@>83b4
                                    ; \ Store 'Hide SID' flag in TI Basic
                                    ; | scratchpad address >83b4.
                                    ; | Note that >83fc in Stevie scratchpad
                                    ; / has copy of the flag.

        mov   @cpu.scrpad2+254,@>83b6
                                    ; \ Store TI Basic session ID in TI Basic
                                    ; | scratchpad address >83b6.
                                    ; | Note that >83fe in Stevie scratchpad has
                                    ; / a copy of the TI basic session ID.
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
        lwpi  cpu.scrpad1           ; Scratchpad in >8300 again
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
        b     @>0070                ; Start GPL interpreter
        ;-------------------------------------------------------
        ; Resume TI-Basic session 1
        ;-------------------------------------------------------
tibasic.resume.basic1:
        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f100,>f000,256  ; / address @cpu.scrpad.target

        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 2
        ;-------------------------------------------------------
tibasic.resume.basic2:
        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f200,>f000,256  ; / address @cpu.scrpad.target

        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 3
        ;-------------------------------------------------------
tibasic.resume.basic3:
        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f300,>f000,256  ; / address @cpu.scrpad.target

        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 4
        ;-------------------------------------------------------
tibasic.resume.basic4:
        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f400,>f000,256  ; / address @cpu.scrpad.target

        jmp   tibasic.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 5
        ;-------------------------------------------------------
tibasic.resume.basic5:
        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f500,>f000,256  ; / address @cpu.scrpad.target
        ;-------------------------------------------------------
        ; Resume TI-Basic session (part 2)
        ;-------------------------------------------------------
tibasic.resume.part2:
        mov   @>83fc,r7             ; Get 'Hide SID' flag
        jeq   tibasic.resume.vdp    ; Flag is reset, skip clearing SID

        li    r7,>8080              ; Whitespace (with TI-Basic offset >60)
        mov   r7,@>b01e             ; Clear SID in VDP screen backup
        ;-------------------------------------------------------
        ; Restore VDP memory
        ;-------------------------------------------------------
tibasic.resume.vdp:
        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore TI Basic 16K VDP memory from
                                    ; RAM buffer >b000->efff

        ;-------------------------------------------------------
        ; Restore scratchpad memory
        ;-------------------------------------------------------
tibasic.resume.scrpad:
        lwpi  cpu.scrpad2           ; Flip workspace before starting restore
        bl    @cpu.scrpad.restore   ; Restore scratchpad from @cpu.scrpad.tgt
        lwpi  cpu.scrpad1           ; Flip workspace to scratchpad again

        mov   @cpu.scrpad2+252,@>83b4
                                    ; \ Store 'Hide SID' flag in TI Basic
                                    ; | scratchpad address >83b4.
                                    ; | Note that >83fc in Stevie scratchpad
                                    ; / has copy of the flag.

        ;-------------------------------------------------------
        ; Load legacy SAMS bank layout
        ;-------------------------------------------------------
tibasic.resume.load:
        lwpi  cpu.scrpad1           ; Workspace must be in scratchpad again!
        clr   r11

        li    r12,>1e00             ; \ Disable SAMS mapper (transparent mode)
        sbz   1                     ; /

        ; ATTENTION
        ; From here on no more access to any of the SP2 or stevie routines.
        ; We're on unknown territory.

        ;-------------------------------------------------------
        ; Resume TI Basic interpreter
        ;-------------------------------------------------------
        b     @>0ab8                ; Return from interrupt routine.
                                    ; See TI Intern page 32 (german)
        ;-------------------------------------------------------
        ; Required values for TI Basic scratchpad
        ;-------------------------------------------------------
tibasic.scrpad.83d4:
        data  >e000
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
        ;--------------------------------------------------------------
        ; Exit ISR if TI-Basic is busy running a program
        ;--------------------------------------------------------------
        mov   @>8344,r7             ; Busy running program?
        ci    r7,>0100
        jne   isr.showid            ; No, TI-Basic is in command line mode.
        ;--------------------------------------------------------------
        ; TI-Basic program running
        ;--------------------------------------------------------------
        jmp   isr.exit              ; Exit
        ;--------------------------------------------------------------
        ; Show TI-Basic session ID ?
        ;--------------------------------------------------------------
isr.showid:
        mov   @>83b4,r7             ; Get counter/Hide flag
        ci    r7,>ffff              ; Hide flag set?
        jeq   isr.hotkey            ; Yes, skip showing session ID
        ci    r7,>0010              ; Counter limit reached ?
        jlt   isr.counter           ; Not yet, skip showing Session ID
        clr   @>83b4                ; Reset counter
        ;--------------------------------------------------------------
        ; Setup VDP write address for column 30
        ;--------------------------------------------------------------
        li    r7,>401e              ; \
        swpb  r7                    ; | >1c is the VDP column position
        movb  r7,@vdpa              ; | where bytes should be written
        swpb  r7                    ; |
        movb  r7,@vdpa              ; /
        ;--------------------------------------------------------------
        ; Dump TI-Basic Session ID to screen
        ;--------------------------------------------------------------
        li    r7,>83df              ; Char '#' and char >df
        movb  r7,@vdpw              ; Write byte
        swpb  r7
        movb  r7,@vdpw              ; Write byte
        jmp   isr.hotkey
        ;-------------------------------------------------------
        ; Increase counter
        ;-------------------------------------------------------
isr.counter:
        inc   @>83b4                ; Increase counter
        ;-------------------------------------------------------
        ; Hotkey pressed?
        ;-------------------------------------------------------
isr.hotkey:
        mov   @>8374,r7             ; \ Get keyboard scancode from @>8375
        andi  r7,>00ff              ; / LSB only
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
* tibasic.return.mon
* Return from OS Monitor/TI Basic to Stevie
***************************************************************
* bl   @tibasic.return.mon
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
tibasic.return.mon:
        li    r12,>1e00             ; \ Enable SAMS mapper again
        sbo   1                     ; | We stil have the SAMS banks layout
                                    ; / mem.sams.layout.external
        ;------------------------------------------------------
        ; Check magic string (inline version, no SP2 present!)
        ;------------------------------------------------------
        c     @magic.str.w1,@magic.string
        jne   !
        c     @magic.str.w2,@magic.string+2
        jne   !
        c     @magic.str.w3,@magic.string+4
        jne   !
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
        mov   @tib.session,tmp0
        ci    tmp0,1
        jlt   !
        ci    tmp0,5
        jgt   !
        jmp   tibasic.return.mon.cont
        ;-------------------------------------------------------
        ; Initialize Stevie
        ;-------------------------------------------------------
!       b     @kickstart.code1      ; Initialize Stevie
        ;-------------------------------------------------------
        ; Resume Stevie
        ;-------------------------------------------------------
tibasic.return.mon.cont:
        lwpi  cpu.scrpad2           ; Activate workspace at >ad00 that was
                                    ; paged out in tibasic.init

        bl    @cpu.scrpad.pgin      ; \ Page-in scratchpad memory previously
              data cpu.scrpad2      ; | stored at >ad00 and set wp at >8300
                                    ; / Destroys registers tmp0-tmp2

        movb  @w$ffff,@>8375        ; Reset keycode

        mov   @tv.sp2.conf,config   ; Restore the SP2 config register

        bl    @mute                 ; Mute sound generators
        bl    @scroff               ; Turn screen off

        ; Prevent resuming the TI Basic session that lead us here.
        ; Easiest thing to do is to reinitalize the session upon next start.

        ;-------------------------------------------------------
        ; Assert TI basic sesion ID
        ;-------------------------------------------------------
        mov   @tib.session,tmp0     ; Get session ID
        jeq   !
        ci    tmp0,5
        jgt   !
        ;-------------------------------------------------------
        ; Reset session resume flag (tibasicX.status)
        ;-------------------------------------------------------
        sla   tmp0,1                ; Word align
        clr   @tib.session(tmp0)
        jmp   tibasic.return.stevie
        ;-------------------------------------------------------
        ; Assert failed
        ;-------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system



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

        lwpi  cpu.scrpad2           ; Activate Stevie workspace that got
                                    ; paged-out in tibasic.init

        movb  @w$ffff,@>8375        ; Reset keycode
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 1
        ;-------------------------------------------------------
tibasic.return.1:
        c     @tib.session,@w$0001
        jne   tibasic.return.2      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f100,256  ; Backup TI Basic scratchpad to >f100
                                    ; @cpu.scrpad.tgt in SAMS bank.
        jmp   !                     ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 2
        ;-------------------------------------------------------
tibasic.return.2:
        c     @tib.session,@w$0002
        jne   tibasic.return.3      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f200,256  ; Backup TI Basic scratchpad to >f200
                                    ; @cpu.scrpad.tgt in SAMS bank.
        jmp   !                     ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 3
        ;-------------------------------------------------------
tibasic.return.3:
        c     @tib.session,@tibasic.const3
        jne   tibasic.return.4      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f300,256  ; Backup TI Basic scratchpad to >f300
                                    ; @cpu.scrpad.tgt in SAMS bank.
        jmp   !                     ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 4
        ;-------------------------------------------------------
tibasic.return.4:
        c     @tib.session,@w$0004
        jne   tibasic.return.5      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f400,256  ; Backup TI Basic scratchpad to >f400
                                    ; @cpu.scrpad.tgt in SAMS bank.
        jmp   !                     ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 5
        ;-------------------------------------------------------
tibasic.return.5:
        c     @tib.session,@tibasic.const5
        jne   tibasic.return.failed ; Not the current session, abort here

        bl    @cpym2m
              data >8300,>f500,256  ; Backup TI Basic scratchpad to >f500
                                    ; @cpu.scrpad.tgt in SAMS bank.
        jmp   !                     ; Skip to page-in
        ;-------------------------------------------------------
        ; Asserts failed
        ;-------------------------------------------------------
tibasic.return.failed:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; Page-in scratchpad memory
        ;-------------------------------------------------------
!       bl    @cpym2m
              data cpu.scrpad2,cpu.scrpad1,256
                                    ; Restore scratchpad contents

        lwpi  cpu.scrpad1           ; Activate primary scratchpad

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


        bl    @tibasic.buildstr     ; Build session identifier string

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

tibasic.const3  data 3
tibasic.const5  data 5

tibasic.patterns:
        byte  >00,>7E,>E7,>C7,>E7,>E7,>C3,>7E ; 1
        byte  >00,>7E,>C3,>F3,>C3,>CF,>C3,>7E ; 2
        byte  >00,>7E,>C3,>F3,>C3,>F3,>C3,>7E ; 3
        byte  >00,>7E,>D3,>D3,>C3,>F3,>F3,>7E ; 4
        byte  >00,>7E,>C3,>CF,>C3,>F3,>C3,>7E ; 5
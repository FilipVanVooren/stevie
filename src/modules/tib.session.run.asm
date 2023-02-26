* FILE......: tib.session.run.asm
* Purpose...: Run TI Basic session


***************************************************************
* tib.run
* Run TI Basic session
***************************************************************
* bl   @tib.run
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
* tib.run >> b @0070 (GPL interpreter/TI Basic)
*         >> isr
*         >> tibasic.return
*
* Memory
* >83b4       ISR counter for triggering periodic actions
* >83b6       TI Basic Session ID
* >f000-ffff  Mailbox Stevie integration
********|*****|*********************|**************************
tib.run:
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
        jeq   tib.run.init.basic1
        ci    tmp0,2
        jeq   tib.run.init.basic2
        ci    tmp0,3
        jeq   tib.run.init.basic3
        ci    tmp0,4
        jeq   tib.run.init.basic4
        ci    tmp0,5
        jeq   tib.run.init.basic5
        ;-------------------------------------------------------
        ; Assert, should never get here
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; New TI Basic session 1
        ;-------------------------------------------------------
tib.run.init.basic1:
        mov   @tib.status1,tmp1     ; Resume TI Basic session?
        jeq   !                     ; No, new session
        b     @tib.run.resume.basic1

!       ori   tmp1,1                ; \
        mov   tmp1,@tib.status1     ; / Set resume flag for next run

        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1

        bl    @cpym2v
              data >06f8,tibasic.patterns,8
                                    ; Copy pattern TI-Basic session ID 1

        jmp   tib.run.init.rest     ; Continue initialisation

abc.test  
        ;text 'OLD TIPI.HW;BAS'
        byte >AF,>AC
        byte >A4,>80     
        byte >B4,>A9     
        byte >B0,>A9     
        byte >8E,>A8     
        byte >B7,>9B     
        byte >A2,>A1     
        byte >B3,>00
        byte 0,0

        ;-------------------------------------------------------
        ; New TI Basic session 2
        ;-------------------------------------------------------
tib.run.init.basic2:
        mov   @tib.status2,tmp1     ; Resume TI Basic session?
        jeq   !                     ; No, new session
        b     @tib.run.resume.basic2

!       ori   tmp1,1                ; \
        mov   tmp1,@tib.status2     ; / Set resume flag for next run

        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2

        bl    @cpym2v
              data >06f8,tibasic.patterns+8,8
                                    ; Copy pattern TI-Basic session ID 2

        jmp   tib.run.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 3
        ;-------------------------------------------------------
tib.run.init.basic3:
        mov   @tib.status3,tmp1     ; Resume TI Basic session?
        jgt   tib.run.resume.basic3 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status3     ; / Set resume flag for next run

        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3

        bl    @cpym2v
              data >06f8,tibasic.patterns+16,8
                                    ; Copy pattern TI-Basic session ID 3

        jmp   tib.run.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 4
        ;-------------------------------------------------------
tib.run.init.basic4:
        mov   @tib.status4,tmp1     ; Resume TI Basic session?
        jgt   tib.run.resume.basic4 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status4     ; / Set resume flag for next run

        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4

        bl    @cpym2v
              data >06f8,tibasic.patterns+24,8
                                    ; Copy pattern TI-Basic session ID 4

        jmp   tib.run.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session 5
        ;-------------------------------------------------------
tib.run.init.basic5:
        mov   @tib.status5,tmp1     ; Resume TI Basic session?
        jgt   tib.run.resume.basic5 ; yes, do resume

        ori   tmp1,1                ; \
        mov   tmp1,@tib.status5     ; / Set resume flag for next run

        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5

        bl    @cpym2v
              data >06f8,tibasic.patterns+32,8
                                    ; Copy pattern TI-Basic session ID 5

        jmp   tib.run.init.rest     ; Continue initialisation
        ;-------------------------------------------------------
        ; New TI Basic session (part 2)
        ;-------------------------------------------------------
tib.run.init.rest:
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
tib.run.resume.basic1:
        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f100,>f000,256  ; / address @cpu.scrpad.target

        jmp   tib.run.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 2
        ;-------------------------------------------------------
tib.run.resume.basic2:
        bl    @mem.sams.set.basic2  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 2

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f200,>f000,256  ; / address @cpu.scrpad.target

        jmp   tib.run.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 3
        ;-------------------------------------------------------
tib.run.resume.basic3:
        bl    @mem.sams.set.basic3  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 3

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f300,>f000,256  ; / address @cpu.scrpad.target

        jmp   tib.run.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 4
        ;-------------------------------------------------------
tib.run.resume.basic4:
        bl    @mem.sams.set.basic4  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 4

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f400,>f000,256  ; / address @cpu.scrpad.target

        jmp   tib.run.resume.part2  ; Continue resume
        ;-------------------------------------------------------
        ; Resume TI-Basic session 5
        ;-------------------------------------------------------
tib.run.resume.basic5:
        bl    @mem.sams.set.basic5  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 5

        bl    @cpym2m               ; \ Copy TI Basic scratchpad to fixed memory
              data >f500,>f000,256  ; / address @cpu.scrpad.target
        ;-------------------------------------------------------
        ; Resume TI-Basic session (part 2)
        ;-------------------------------------------------------
tib.run.resume.part2:
        mov   @>83fc,r7             ; Get 'Hide SID' flag
        jeq   tib.run.resume.vdp    ; Flag is reset, skip clearing SID

        li    r7,>8080              ; Whitespace (with TI-Basic offset >60)
        mov   r7,@>b01e             ; Clear SID in VDP screen backup
        ;-------------------------------------------------------
        ; Restore VDP memory
        ;-------------------------------------------------------
tib.run.resume.vdp:
        bl    @cpym2v
              data >0000,>b000,16384
                                    ; Restore TI Basic 16K VDP memory from
                                    ; RAM buffer >b000->efff
        ;-------------------------------------------------------
        ; Clear crunch buffer (crunched statement from before)
        ;-------------------------------------------------------
        bl    @cpym2v
              data >02e2,abc.test,15 ; OLD TIPI.HW;BAS

        bl    @filv
              data >0320,0,80       ; \ Clear crunch buffer to remove statement
                                    ; / used for returning to Stevie before.                                    
        ;-------------------------------------------------------
        ; Restore scratchpad memory
        ;-------------------------------------------------------
tib.run.resume.scrpad:
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
        sbz   1                     ; / >02 >03 >0a >0b >0c >0d >0e >0f

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
* Patterns for session indicator digits 1-5
********|*****|*********************|**************************
tibasic.patterns:
        byte  >00,>7E,>E7,>C7,>E7,>E7,>C3,>7E ; 1
        byte  >00,>7E,>C3,>F3,>C3,>CF,>C3,>7E ; 2
        byte  >00,>7E,>C3,>F3,>C3,>F3,>C3,>7E ; 3
        byte  >00,>7E,>D3,>D3,>C3,>F3,>F3,>7E ; 4
        byte  >00,>7E,>C3,>CF,>C3,>F3,>C3,>7E ; 5

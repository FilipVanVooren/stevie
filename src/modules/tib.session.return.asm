* FILE......: tib.session.return.asm
* Purpose...: Return from TI Basic session to Stevie


***************************************************************
* tib.run.return.mon
* Return from OS Monitor to Stevie
***************************************************************
* bl   @tib.run.return.mon
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1
*--------------------------------------------------------------
* REMARKS
* Only called from program selection screen after exit out of 
* TI Basic with FCTN-QUIT, BYE or by running an assembly 
* program that did "BLWP @0".
********|*****|*********************|**************************
tib.run.return.mon:
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
        jmp   tib.run.return.mon.cont
        ;-------------------------------------------------------
        ; Initialize Stevie
        ;-------------------------------------------------------
!       b     @kickstart.code1      ; Initialize Stevie
        ;-------------------------------------------------------
        ; Resume Stevie
        ;-------------------------------------------------------
tib.run.return.mon.cont:
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
        jmp   tib.run.return.stevie
        ;-------------------------------------------------------
        ; Assert failed
        ;-------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system



***************************************************************
* tib.run.return
* Return from TI Basic to Stevie
***************************************************************
* bl   @tib.run.return
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
tib.run.return:
        li    r12,>1e00             ; \ Enable SAMS mapper again with        
        sbo   1                     ; | sams layout table
                                    ; / mem.sams.layout.basic[1-5]

        lwpi  cpu.scrpad2           ; Activate Stevie workspace that got
                                    ; paged-out in tibasic.init

        movb  @w$ffff,@>8375        ; Reset keycode

        
        sbo   0                     ; Enable writing to SAMS registers
        mov   @tib.run.return.data.samspage,@>401c
                                    ; \ Temporarily map SAMS page >0f to
                                    ; | memory window >0e00 - >0eff
                                    ; |
                                    ; | Needed for copying BASIC program
                                    ; | filename at >ef00 to destination >f?00 
                                    ; | in SAMS page >ff
                                    ; /
        sbz   0                     ; Disable writing to SAMS registers

        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 1
        ;-------------------------------------------------------
tib.run.return.1:
        c     @tib.session,@const.1
        jne   tib.run.return.2      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f100,256  ; Backup TI Basic scratchpad to >f100

        bl    @cpym2m
              data >ef00,>f600,256  ; Backup auxiliary memory to >f600

        jmp   tib.return.page_in    ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 2
        ;-------------------------------------------------------
tib.run.return.2:
        c     @tib.session,@const.2
        jne   tib.run.return.3      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f200,256  ; Backup TI Basic scratchpad to >f200

        bl    @cpym2m
              data >ef00,>f700,256  ; Backup auxiliary memory to >f700

        jmp   tib.return.page_in    ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 3
        ;-------------------------------------------------------
tib.run.return.3:
        c     @tib.session,@const.3
        jne   tib.run.return.4      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f300,256  ; Backup TI Basic scratchpad to >f300

        bl    @cpym2m
              data >ef00,>f800,256  ; Backup auxiliary memory to >f800

        jmp   tib.return.page_in    ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 4
        ;-------------------------------------------------------
tib.run.return.4:
        c     @tib.session,@const.4
        jne   tib.run.return.5      ; Not the current session, check next one.

        bl    @cpym2m
              data >8300,>f400,256  ; Backup TI Basic scratchpad to >f400

        bl    @cpym2m
              data >ef00,>f900,256  ; Backup auxiliary memory to >f900

        jmp   tib.return.page_in    ; Skip to page-in
        ;-------------------------------------------------------
        ; Backup scratchpad of TI-Basic session 5
        ;-------------------------------------------------------
tib.run.return.5:
        c     @tib.session,@const.5
        jne   tib.run.return.failed ; Not the current session, abort here

        bl    @cpym2m
              data >8300,>f500,256  ; Backup TI Basic scratchpad to >f500

        bl    @cpym2m
              data >ef00,>fa00,256  ; Backup auxiliary memory to >fa00

        jmp   tib.return.page_in    ; Skip to page-in
        ;-------------------------------------------------------
        ; Asserts failed
        ;-------------------------------------------------------
tib.run.return.failed:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; Page-in scratchpad memory
        ;-------------------------------------------------------        
tib.return.page_in:
        sbo   0                     ; Enable writing to SAMS registers

        mov   @tib.samstab.ptr,tmp0 ; \ Get pointer to basic session SAMS table. 
        ai    tmp0,12               ; / Get 7th entry in table

        mov   *tmp0,@>401c          ; \ Restore SAMS page in
                                    ; | memory window >0e00 - >0eff
                                    ; | Was temporarily paged-out 
                                    ; | in tib.return.run
                                    ; / Required before doing VDP memory dump

        sbz   0                     ; Disable writing to SAMS registers

        bl    @cpym2m
              data cpu.scrpad2,cpu.scrpad1,256
                                    ; Restore scratchpad contents

        lwpi  cpu.scrpad1           ; Activate primary scratchpad

        mov   @tv.sp2.conf,config   ; Restore the SP2 config register

        bl    @mute                 ; Mute sound generators
        ;-------------------------------------------------------
        ; Cleanup after return from TI Basic
        ;-------------------------------------------------------
tib.run.return.vdpdump:        
        bl    @scroff               ; Turn screen off
        bl    @cpyv2m
              data >0000,>b000,16384
                                    ; Dump TI Basic 16K VDP memory to ram buffer
                                    ; >b000->efff
        ;-------------------------------------------------------
        ; Restore VDP screen with Stevie content
        ;-------------------------------------------------------
tib.run.return.stevie:
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

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF

        mov   @tib.autounpk,tmp0    ; AutoUnpack is on?
        jne   tib.run.return.exit   ; Yes, skip keylist
        ;------------------------------------------------------
        ; Set shortcut list in bottom status line
        ;------------------------------------------------------
        li    tmp0,txt.keys.basic1
        mov   tmp0,@cmdb.pankeys    ; Save Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tib.run.return.exit:
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

tib.run.return.data.samspage
        data  >0f00                 ; SAMS page >0f

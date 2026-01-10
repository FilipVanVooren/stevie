* FILE......: tib.session.return.asm
* Purpose...: Return from TI Basic session to Stevie

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
                                    ; / mem.sams.layout.basic[1-3]

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
        jne   tib.run.return.failed ; Not the current session, abort here

        bl    @cpym2m
              data >8300,>f300,256  ; Backup TI Basic scratchpad to >f300

        bl    @cpym2m
              data >ef00,>f800,256  ; Backup auxiliary memory to >f800

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
        ; Setup F18a again
        ;-------------------------------------------------------
        bl    @f18unl               ; Unlock the F18a

        .ifeq vdpmode, 3080

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        .ifeq vdpmode, 6080

        bl    @putvr                ; Turn on 30 rows mode.
              data >3140            ; F18a VR49 (>31), bit 40

        .endif

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        bl    @putvr                ; Set stop sprite
              data >3300            ; F18a VR51 (>33), no sprites
        ;-------------------------------------------------------
        ; Restore video mode & content
        ;-------------------------------------------------------
        bl    @vidtab               ; Load video mode table into VDP
              data stevie.80x30     ; Equate selected video mode table

        bl    @putvr                ; Turn on position based attributes
              data >3202            ; F18a VR50 (>32), bit 2

        clr   @parm1                ; Screen off while reloading color scheme
        clr   @parm2                ; Don't skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF

        bl    @fb.calc.scrrows      ; Calculate number of rows 
                                    ; \ i  @tv.ruler.visible = Ruler visible
                                    ; | i  @edb.special.file = Special file flag
                                    ; / i  @tv.error.visible = Error visible
        ;------------------------------------------------------
        ; Refresh Basic dialog
        ;------------------------------------------------------
tib.run.return.refresh:
        bl    @dialog.basic         ; Refresh Basic dialog content
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)   
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

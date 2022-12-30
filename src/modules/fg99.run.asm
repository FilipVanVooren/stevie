* FILE......: fg99.run.asm
* Purpose...: Run FinalGROM cartridge image


***************************************************************
* fg99.run
* Run FinalGROM cartridge image
***************************************************************
* bl   @fg99.run
*--------------------------------------------------------------
* INPUT
* @tv.fg99.img.ptr = Pointer to cartridge image entry
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* r1 in GPL WS, tmp0, tmp1, tmp2, r12
*--------------------------------------------------------------
* Remarks
* Based on tib.run
********|*****|*********************|**************************
fg99.run:
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

        bl    @scroff
        ;-------------------------------------------------------
        ; New TI Basic session 1
        ;-------------------------------------------------------
        bl    @mem.sams.set.basic1  ; \ Load SAMS page layout (from cart space)
                                    ; / for TI Basic session 1
fg99.run.init.rest:
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

        mov   @tv.fg99.img.ptr,tmp0 ; Get pointer to cartridge image
        bl    @xfg99                ; Run FinalGROM cartridge image
                                    ; \ i tmp0 = Pointer to cartridge image
                                    ; /

        ;lwpi  cpu.scrpad2           ; Flip workspace before starting restore
        ;bl    @cpu.scrpad.restore   ; Restore scratchpad from @cpu.scrpad.tgt
        ;lwpi  cpu.scrpad1           ; Flip workspace to scratchpad again

        ; ATTENTION
        ; From here on no more access to any of the SP2 or stevie routines.
        ; We're on unknown territory.

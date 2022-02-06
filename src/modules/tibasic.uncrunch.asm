* FILE......: tibasic.uncrunch.asm
* Purpose...: Uncrunch TI Basic program to editor buffer


***************************************************************
* tibasic.uncrunch
* Uncrunch TI Basic program to editor buffer
***************************************************************
* bl   @tibasic.uncrunch
*--------------------------------------------------------------
* INPUT
* @parm1 = TI Basic session to uncrunch (1-5)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, r12
*--------------------------------------------------------------
* Remarks
* @tib.var1 = Copy @parm1
*
* Pointers:
* @tib.scrpad.ptr = Scratchpad address in SAMS page >ff
* @tib.stab.ptr   = SAMS page layout table of TI Basic session
*
* Pointers to tables in VRAM:
* @tib.lnt.top.ptr  = Top of line number table
* @tib.lnt.bot.ptr  = Bottom of line number table
* @tib.symt.top.ptr = Top of symbol table
* @tib.symt.bot.ptr = Bottom of symbol table
* @tib.strs.top.ptr = Top of string space
* @tib.strs.bot.ptr = Bottom of string space
********|*****|*********************|**************************
tibasic.uncrunch:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        ;------------------------------------------------------
        ; (1) Assert on TI basic session
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get session to uncrunch
        mov   tmp0,@tib.var1        ; Make copy

        ci    tmp0,1                ; \
        jlt   !                     ; | Skip to (2) if valid
        ci    tmp0,5                ; | session ID.
        jle   tibasic.uncrunch.2    ; /
        ;------------------------------------------------------
        ; Assert failed
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; (2) Get scratchpad of TI Basic session
        ;------------------------------------------------------
tibasic.uncrunch.2:
        bl    @sams.page.set        ; Set SAMS page
              data >00ff,>f000      ; \ i  p1  = SAMS page number
                                    ; / i  p2  = Memory map address

        ; TI Basic session 1 scratchpad >f100
        ; TI Basic session 2 scratchpad >f200
        ; TI Basic session 3 scratchpad >f300
        ; TI Basic session 4 scratchpad >f400
        ; TI Basic session 5 scratchpad >f500

        mov   @tib.var1,tmp0        ; Get TI Basic session
        sla   tmp0,8                ; Get scratchpad offset (>100->500)
        ai    tmp0,>f000            ; Add base address
        mov   tmp0,@tib.scrpad.ptr  ; Store pointer to scratchpad in SAMS
        ;------------------------------------------------------
        ; (3) Get relevant pointers stored in scratchpad
        ;------------------------------------------------------
tibasic.uncrunch.3:
        mov   @>18(tmp0),@tib.strs.top.ptr
                                    ; @>8318 Pointer to top of string space
                                    ; in VRAM

        mov   @>1a(tmp0),@tib.strs.bot.ptr
                                    ; @>831a Pointer to bottom of string space
                                    ; in VRAM

        mov   @>30(tmp0),@tib.lnt.top.ptr
                                    ; @>8330 Pointer to top of line number
                                    ; table in VRAM

        mov   @>32(tmp0),@tib.lnt.bot.ptr
                                    ; @>8332 Pointer to bottom of line number
                                    ; table in VRAM

        mov   @tib.lnt.bot.ptr,@tib.symt.top.ptr
        dect  @tib.symt.top.ptr     ; Pointer to top of symbol table in VRAM.
                                    ; Table top is just below the bottom of
                                    ; the line number table.

        mov   @>3e(tmp0),@tib.symt.bot.ptr
                                    ; @>833e Pointer to bottom of symbol table
                                    ; in VRAM
        ;------------------------------------------------------
        ; (3) Get index into SAMS layout data table
        ;------------------------------------------------------
tibasic.uncrunch.4:
        ; The data tables of the 5 TI basic sessions form a
        ; uniform region, we calculate the index of the 1st word in the
        ; specified session.
        mov   @tib.var1,tmp0        ; Get TI Basic session

        sla   tmp0,4                ; \ Get index of first word in SAMS page
                                    ; | layout (of following TI Basic session)
                                    ; /

        ai    tmp0,mem.sams.layout.basic - 16
                                    ; Add base address for specified session

        mov   tmp0,@tib.stab.ptr    ; Save pointer
        ;------------------------------------------------------
        ; (4) Prepare for traversing crunched program
        ;------------------------------------------------------


        ;------------------------------------------------------
        ; (9) Prepare for exit
        ;------------------------------------------------------
tibasic.uncrunch.9:
        mov   @tv.sams.f000,tmp0    ; Get SAMS page number
        srl   tmp0,8                ; Move to LSB

        li    tmp1,>f000            ; Map SAMS page to >f000-ffff

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address

        bl    @fb.refresh           ; Refresh frame buffer content
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.uncrunch.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

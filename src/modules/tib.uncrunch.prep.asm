* FILE......: tib.uncrunch.prep.asm
* Purpose...: Uncrunch TI Basic program to editor buffer


***************************************************************
* tib.uncrunch.prepare
* Prepare for uncrunching TI-Basic program
***************************************************************
* bl   @tib.uncrunch.prepare
*--------------------------------------------------------------
* INPUT
* @parm1 = TI Basic session to uncrunch (1-5)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
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
*
* Variables
* @tib.var1  = TI Basic session
* @tib.var2  = Address of SAMS page layout table entry mapped to VRAM address
* @tib.var3  = SAMS page ID mapped to VRAM address
* @tib.lines = Number of lines in TI Basic program
********|*****|*********************|**************************
tib.uncrunch.prepare:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @tib.var1             ;
        clr   @tib.var2             ; Clear temporary variables
        clr   @tib.var3             ;
        clr   @tib.var4             ;
        clr   @tib.var5             ;
        ;------------------------------------------------------
        ; (1) Assert on TI basic session
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Get session to uncrunch
        mov   tmp0,@tib.var1        ; Make copy

        ci    tmp0,1                ; \
        jlt   !                     ; | Skip to (2) if valid
        ci    tmp0,5                ; | session ID.
        jle   tib.uncrunch.prepare.2; /
        ;------------------------------------------------------
        ; Assert failed
        ;------------------------------------------------------
!       mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; (2) Get scratchpad of TI Basic session
        ;------------------------------------------------------
tib.uncrunch.prepare.2:
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
        mov   @>18(tmp0),@tib.strs.top.ptr
                                    ; @>8318 Pointer to top of string space
                                    ; in VRAM

        mov   @>1a(tmp0),@tib.strs.bot.ptr
                                    ; @>831a Pointer to bottom of string space
                                    ; in VRAM

        mov   @>30(tmp0),@tib.lnt.bot.ptr
                                    ; @>8330 Pointer to bottom of line number
                                    ; table in VRAM

        mov   @>32(tmp0),@tib.lnt.top.ptr
                                    ; @>8332 Pointer to top of line number
                                    ; table in VRAM

        mov   @tib.lnt.bot.ptr,@tib.symt.top.ptr
        dect  @tib.symt.top.ptr     ; Pointer to top of symbol table in VRAM.
                                    ; Table top is just below the bottom of
                                    ; the line number table.

        mov   @>3e(tmp0),@tib.symt.bot.ptr
                                    ; @>833e Pointer to bottom of symbol table
                                    ; in VRAM
        ;------------------------------------------------------
        ; (4) Calculate number of lines in TI Basic program
        ;------------------------------------------------------
        mov   @tib.lnt.top.ptr,tmp0 ; \ Size of line number table entry: 4 bytes
        s     @tib.lnt.bot.ptr,tmp0 ; /
        jeq   tib.uncrunch.prepare.np

        inc   tmp0                  ; One time offset
        srl   tmp0,2                ; tmp0=tmp0/4
        mov   tmp0,@tib.lines       ; Save lines
        jmp   tib.uncrunch.prepare.5
        ;------------------------------------------------------
        ; No program present
        ;------------------------------------------------------
tib.uncrunch.prepare.np:
        clr   @tib.lines            ; No program
        ;------------------------------------------------------
        ; (5) Get pointer to SAMS page table
        ;------------------------------------------------------
tib.uncrunch.prepare.5:
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
        ; Exit
        ;------------------------------------------------------
tib.uncrunch.prepare.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

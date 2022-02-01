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
* @tibasic.var1 = >8330, pointer to VDP linenum table bottom
* @tibasic.var2 = >8332, pointer to VDP linenum table top
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
        ; (2) Get index into SAMS layout data table
        ;------------------------------------------------------
tibasic.uncrunch.2:
        ; The data tables of the 5 TI basic sessions form a
        ; uniform region, we calculate the index into the last
        ; word of the specified session.

        sla   tmp0,4                ; \ Get index of first word
                                    ; | in data table with SAMS
                                    ; | layout (of following
                                    ; / session!)

        ai    tmp0,-2               ; Offset in SAMS data layout
                                    ; table (f000-ffff) in
                                    ; current session

        mov   tmp0,@tibasic.var10   ; Save index offset for later use

        mov   @mem.sams.layout.basic(tmp0),tmp0
                                    ; Get SAMS page
        srl   tmp0,8                ; Move to LSB
        ;------------------------------------------------------
        ; (3) Get scratchpad page of current TI Basic session
        ;------------------------------------------------------
tibasic.uncrunch.3:
        li    tmp1,>f000            ; Map SAMS page to >f000-ffff
        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address

        ; The scratchpad >8300 - >83ff as used by the specified
        ; TI Basic session was previously saved by the subroutine
        ; "tibasic.return" upon return from TI Basic to Stevie.
        ; The relevant address range is >f960 - >f9ff

        mov   @>f990,@tibasic.var1  ; @>8330 Save pointer to linenum table bot.
        mov   @>f992,@tibasic.var2  ; @>8332 Save pointer to linenum table top.

        ;------------------------------------------------------
        ; (3) Prepare for traversing crunched program
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

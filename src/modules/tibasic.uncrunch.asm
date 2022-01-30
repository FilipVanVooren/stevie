* FILE......: tibasic.uncrunch.asm
* Purpose...: Uncrunch TI Basic program to editor buffer



***************************************************************
* tibasic.uncrunch
* Uncrunch TI Basic program to editor buffer
***************************************************************
* bl   @tibasic.uncrunch
*--------------------------------------------------------------
* INPUT
* @tibasic.session = TI Basic session to uncrunch
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
        ; (1) Get index into SAMS layout data table
        ;------------------------------------------------------
        mov   @tibasic.session,tmp0 ; Get current session
        sla   tmp0,4                ; \ Get index of first word
                                    ; | in data table with SAMS
                                    ; | layout (of following
                                    ; / session!)

        ai    tmp0,-2               ; Offset in SAMS data layout
                                    ; table of f000-ffff in
                                    ; current session

        mov   tmp0,tibasic.var10    ; Save index
        ;------------------------------------------------------
        ; (2) Get scratchpad page of current TI Basic session
        ;------------------------------------------------------
        mov   @tibasic.sams.layout.basic(tmp0),tmp0
                                    ; Get SAMS page number

        li    tmp1,>f000            ; Map SAMS page to >f000-ffff

        bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory map address

        mov   @>f030,@tibasic.var1  ; Save pointer to linenum table bot
        mov   @>f032,@tibasic.var2  ; Save pointer to linenum table top
        ;------------------------------------------------------
        ; (3) Prepare for traversing crunched program
        ;------------------------------------------------------



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

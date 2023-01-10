* FILE......: tib.dialog.helper.asm
* Purpose...: TI Basic dialog helper functions



***************************************************************
* tibasic.am.toggle
* Toggle TI Basic AutoUnpack
***************************************************************
* bl   @tibasic.am.toggle
*--------------------------------------------------------------
* INPUT
* none
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
tibasic.am.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle AutoUnpack display
        ;------------------------------------------------------
        inv   @tib.autounpk         ; Toggle 'AutoUnpack'
        jeq   tibasic.am.off
        li    tmp0,txt.keys.basic2
        jmp   !
tibasic.am.off:
        li    tmp0,txt.keys.basic
!       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.am.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return




***************************************************************
* tibasic.buildstr
* Build session picker string for TI Basic dialog
***************************************************************
* bl   @tibasic.buildstr
*--------------------------------------------------------------
* INPUT
* none
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
tibasic.buildstr:
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
        ;-------------------------------------------------------
        ; Build session selection string
        ;-------------------------------------------------------
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        bl    @cpym2m
              data txt.info.basic,rambuf+200,30
                                    ; Copy string from rom to ram buffer

        li    tmp0,rambuf + 200     ; \
        mov   tmp0,@cmdb.paninfo    ; / Set pointer to session selection string

        li    tmp0,tib.status1      ; First TI Basic session to check
        li    tmp2,tib.status5      ; Last TI Basic session to check
        li    tmp3,rambuf + 212     ; Position in session selection string
        li    tmp4,1                ; Session counter
        ;-------------------------------------------------------
        ; Loop over TI Basic sessions and check if active
        ;-------------------------------------------------------
tibasic.buildstr.loop:
        mov   *tmp0+,tmp1           ; Session active?
        jeq   tibasic.buildstr.next
                                    ; No, check next session
        ;-------------------------------------------------------
        ; Current session?
        ;-------------------------------------------------------
tibasic.buildstr.current:
        c     tmp4,@tib.session     ; Matches current session?
        jne   tibasic.buildstr.active

        movb  @tibasic.heart.solid,*tmp3+
        movb  @tibasic.heart.solid+1,*tmp3
                                    ; Set marker
        dec   tmp3                  ; Adjustment

        jmp   tibasic.buildstr.next ; Next entry
        ;-------------------------------------------------------
        ; Set Basic session active marker
        ;-------------------------------------------------------
tibasic.buildstr.active:
        movb  @tibasic.heart.open,*tmp3+
        movb  @tibasic.heart.open+1,*tmp3
                                    ; Set marker
        dec   tmp3                  ; Adjustment
        ;-------------------------------------------------------
        ; Next entry
        ;-------------------------------------------------------
tibasic.buildstr.next:
        ai    tmp3,4                ; Next position
        c     tmp0,tmp2             ; All sessions checked?
        jgt   tibasic.buildstr.exit ; Yes, exit loop
        inc   tmp4                  ; Next session
        jmp   tibasic.buildstr.loop ; No, next iteration
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tibasic.buildstr.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

tibasic.heart.solid:
        byte  2,3                   ; ASCII 2-3 (heart solid)
tibasic.heart.open:
        byte  29,30                 ; ASCII 29-30 (heart open)

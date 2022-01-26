* FILE......: tibasic.helper.asm
* Purpose...: TI Basic dialog helper functions



***************************************************************
* tibasic.sid
* Toggle TI Basic SID display
***************************************************************
* bl   @tibasic.sid.toggle
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
tibasic.sid.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle SID display
        ;------------------------------------------------------
        inv   @tibasic.hidesid      ; Toggle 'Hide SID'
        jeq   tibasic.sid.off
        li    tmp0,txt.keys.basic2
        jmp   !
tibasic.sid.off:
        li    tmp0,txt.keys.basic
!       mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
tibasic.sid.exit:
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
        ;-------------------------------------------------------
        ; Build session selection string
        ;-------------------------------------------------------
        bl    @cpym2m
              data txt.info.basic,rambuf+200,28
                                    ; Copy string from rom to ram buffer

        li    tmp0,rambuf + 200     ; \
        mov   tmp0,@cmdb.paninfo    ; / Set pointer to session selection string

        li    tmp0,tibasic1.status  ; First TI Basic session to check
        li    tmp2,tibasic5.status  ; Last TI Basic session to check
        li    tmp3,rambuf + 212     ; Position in session selection string
        ;-------------------------------------------------------
        ; Loop over TI Basic sessions and check if active
        ;-------------------------------------------------------
tibasic.buildstr.loop:
        mov   *tmp0+,tmp1           ; Session active?
        jeq   tibasic.buildstr.next
                                    ; No, check next session
        ;-------------------------------------------------------
        ; Set Basic session active marker
        ;-------------------------------------------------------
        movb  @tibasic.buildstr.data.marker,*tmp3
                                    ; Set marker
        ;-------------------------------------------------------
        ; Next entry
        ;-------------------------------------------------------
tibasic.buildstr.next:
        ai    tmp3,4                ; Next position
        c     tmp0,tmp2             ; All sessions checked?
        jgt   tibasic.buildstr.exit ; Yes, exit loop
        jmp   tibasic.buildstr.loop ; No, next iteration
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tibasic.buildstr.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

tibasic.buildstr.data.marker:
       data   >2a00                 ; ASCII 42 (*)
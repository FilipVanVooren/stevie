* FILE......: tibasic.dialog.helper.asm
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
        inv   @tib.hidesid          ; Toggle 'Hide SID'
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
        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)

        bl    @cpym2m
              data txt.info.basic,rambuf+200,30
                                    ; Copy string from rom to ram buffer

        li    tmp0,rambuf + 200     ; \
        mov   tmp0,@cmdb.paninfo    ; / Set pointer to session selection string

        li    tmp0,tib.status1      ; First TI Basic session to check
        li    tmp2,tib.status5      ; Last TI Basic session to check
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
        movb  @tibasic.buildstr.data.marker,*tmp3+
        movb  @tibasic.buildstr.data.marker+1,*tmp3
                                    ; Set marker
        dec   tmp3                  ; Adjustment
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
        byte  29,30                 ; ASCII 29-30 (check marker)



***************************************************************
* tibasic.hearts.tat
* Dump color for hearts in TI Basic session dialog
***************************************************************
* bl   @tibasic.hearts.tat
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
tibasic.hearts.tat:
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
        ; Get background color for hearts in TAT
        ;-------------------------------------------------------
        bl    @vgetb                ; Read VDP byte
              data vdp.cmdb.toprow.tat + 91
                                    ; 2nd row in CMDB, column 11

        mov   tmp0,tmp1             ; Save color combination
        andi  tmp1,>000f            ; Only keep background
        ori   tmp1,>0060            ; Set foreground color to red

        li    tmp0,vdp.cmdb.toprow.tat+91
                                    ; 2nd row in CMDB, column 11

        mov   tmp0,tmp4             ; Backup TAT position
        mov   tmp1,tmp3             ; Backup color combination
        ;-------------------------------------------------------
        ; Dump colors for 5 hearts if in TI Basic dialog (TAT)
        ;-------------------------------------------------------
tibasic.hearts.tat.loop:
        mov   tmp4,tmp0             ; Get VDP address in TAT
        mov   tmp3,tmp1             ; Get VDP byte to write
        li    tmp2,2                ; Number of bytes to fill

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill

        ai    tmp4,4                ; Next heart in TAT

        li    tmp1,vdp.cmdb.toprow.tat+110
        c     tmp4,tmp1
        jle   tibasic.hearts.tat.loop
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
tibasic.hearts.tat.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
* FILE......: edb.autoinsert.asm
* Purpose...: Toggle auuto insert mode for editor buffer


***************************************************************
* edb.autoinsert
* Toggle auto insert mode for editor buffer
***************************************************************
*  bl   @edb.autoinsert.toggle
*--------------------------------------------------------------
* INPUT
* @edb.autoinsert = Flag for tracking auto insert mode
* @edb.locked     = Editor buffer locked flag
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
edb.autoinsert.toggle:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Check if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor locked?
        jne   edb.autoinsert.toggle.exit   
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Toggle auto insert mode
        ;-------------------------------------------------------
        bl    @hchar
              byte 0,50,32,20
              data EOL              ; Erase any previous message

        inv   @edb.autoinsert       ; Toggle AutoInsert mode
        jeq   !
        ;-------------------------------------------------------
        ; Show message 'AutoInsert on'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.autoins.on   ; AutoInsert on
        jmp   edb.autoinsert.oneshot
        ;-------------------------------------------------------
        ; Show message 'AutoInsert off'
        ;-------------------------------------------------------
!       bl    @putat
              byte 0,52
              data txt.autoins.off   ; AutoInsert off
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
edb.autoinsert.oneshot:
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edb.autoinsert.toggle.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

txt.autoins.on     stri 'Auto insert: ON'
                   even
txt.autoins.off    stri 'Auto insert: OFF'
                   even
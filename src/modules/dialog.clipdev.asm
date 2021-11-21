* FILE......: dialog.clipdev.asm
* Purpose...: Dialog "Configure clipboard device"

***************************************************************
* dialog.clipdev
* Open Dialog "Configure clipboard device"
***************************************************************
* b @dialog.clipdevice
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.clipdev:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.clipdev
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.clipdev
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers
        
        li    tmp0,txt.hint.clipdev
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.clipdev
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2 
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.clipdevice.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller     
* FILE......: dialog.cfg.mc.asm
* Purpose...: Dialog "Configure Master Catalog"

***************************************************************
* dialog.cfg.mc
* Open Dialog "Configure Master Catalog"
***************************************************************
* bl @dialog.cfg.mc
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
dialog.cfg.mc:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.cfg.mc
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.cfg.mc
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.cfg.mc
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.keys.cfg.mc
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------
        li    tmp0,tv.mc.fname      ; Set clipboard
        mov   tmp0,@parm1           ; Get pointer to string

        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.cfg.mc.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

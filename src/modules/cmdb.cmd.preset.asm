* FILE......: cmdb.cmd.preset.asm
* Purpose...: Set command to preset based on dialog and shortcut pressed

***************************************************************
* cmdb.cmd.preset
* Set command to preset based on dialog and shortcut pressed
***************************************************************
* bl   @cmdb.cmd.preset
*--------------------------------------------------------------
* INPUT
* @waux1       = Key pressed
* @cmdb.dialog = ID of current dialog
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
cmdb.cmd.preset:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        li    tmp0,cmdb.cmd.preset.data
                                    ; Load table
        mov   @keycode1,tmp2        ; Get keyboard code
        ;-------------------------------------------------------
        ; Loop over table with presets
        ;-------------------------------------------------------
cmdb.cmd.preset.loop:
        c     *tmp0+,@cmdb.dialog   ; Dialog matches?
        jne   cmdb.cmd.preset.next  ; No, next entry
        ;-------------------------------------------------------
        ; Dialog matches, check if shortcut matches
        ;-------------------------------------------------------
        c     *tmp0+,tmp2           ; Compare with keyboard shortcut
        jne   !                     ; No match, next entry
        ;-------------------------------------------------------
        ; Entry in table matches, set preset
        ;-------------------------------------------------------
        mov   *tmp0,@parm1          ; Get pointer to string

        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /

        bl    @cmdb.cmd.cursor_eol  ; Cursor at EOL

        jmp   cmdb.cmd.preset.exit  ; Exit
        ;-------------------------------------------------------
        ; Dialog does not match, prepare for next entry
        ;-------------------------------------------------------
cmdb.cmd.preset.next:
        inct  tmp0                  ; Skip shortcut
!       inct  tmp0                  ; Skip pointer to string
        ;-------------------------------------------------------
        ; End of list reached?
        ;-------------------------------------------------------
        mov   *tmp0,tmp1            ; Get entry
        ci    tmp1,EOL              ; EOL identifier found?
        jne   cmdb.cmd.preset.loop  ; Not yet, next entry
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
cmdb.cmd.preset.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller    

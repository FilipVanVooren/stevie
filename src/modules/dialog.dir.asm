* dir......: dialog.dir.asm
* Purpose...: Dialog "Dir"

***************************************************************
* dialog.dir
* Open Dialog "Dir"
***************************************************************
* bl @dialog.dir
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
dialog.dir:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.dir
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.dir
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.dir
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.hint.dir2        
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display
        li    tmp0,txt.keys.dir     ; Key list
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.dir.keylist:
        mov   tmp0,@cmdb.pankeys    ; Show keylist in status line
        ;-------------------------------------------------------
        ; Set filename (1) 
        ;-------------------------------------------------------
dialog.dir.set.filename1:
        li    tmp0,cat.device       ; Get pointer to catalog device name
        mov   *tmp0,tmp1            ; Anything set?
        jeq   dialog.dir.browser    ; No device set

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
        ;-------------------------------------------------------
        ; Show File browser
        ;-------------------------------------------------------
dialog.dir.browser:        
        bl    @pane.filebrowser     ; Show file browser
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.dir.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.dir.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

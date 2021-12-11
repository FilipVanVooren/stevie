* FILE......: dialog.load.asm
* Purpose...: Dialog "Load DV80 file"

***************************************************************
* dialog.load
* Open Dialog for loading DV 80 file
***************************************************************
* b @dialog.load
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.load:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0       ; Editor dirty?
        jeq   dialog.load.setup     ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   dialog.load.exit      ; Exit early
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.load.setup:        
        bl    @fb.scan.fname        ; Get possible device/filename

        li    tmp0,id.dialog.load
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.load
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers        

        li    tmp0,txt.hint.load
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        abs   @fh.offsetopcode      ; FastMode is off ? 
        jeq   ! 
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.load2   ; Highlight FastMode
        jmp   dialog.load.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.load 
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.load.keylist:
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;-------------------------------------------------------
        ; Set command line
        ;-------------------------------------------------------         
        li    tmp0,cmdb.dflt.fname  ; Get pointer to default filename
        mov   *tmp0,tmp1            ; Anything set?
        jeq   dialog.load.cursor    ; No default filename, skip

        mov   tmp0,@parm1           ; Get pointer to string
        bl    @cmdb.cmd.set         ; Set command value
                                    ; \ i  @parm1 = Pointer to string w. preset
                                    ; /
        ;-------------------------------------------------------
        ; Set cursor shape
        ;-------------------------------------------------------
dialog.load.cursor:
        bl    @pane.cursor.blink    ; Show cursor
        mov   @tv.curshape,@ramsat+2 
                                    ; Get cursor shape and color
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.load.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller                                         
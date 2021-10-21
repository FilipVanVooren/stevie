* FILE......: dialog.insert.asm
* Purpose...: Dialog "Insert DV80 file"

***************************************************************
* dialog.insert
* Open Dialog for inserting DV 80 file
***************************************************************
* b @dialog.insert
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
dialog.insert:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.insert.setup:        
        li    tmp0,id.dialog.insert
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.insert
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt
        clr   @cmdb.panmarkers      ; No key markers        

        li    tmp0,txt.hint.insert
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        abs   @fh.offsetopcode      ; FastMode is off ? 
        jeq   ! 
        ;-------------------------------------------------------
        ; Show that FastMode is on
        ;-------------------------------------------------------
        li    tmp0,txt.keys.insert  ; Highlight FastMode
        jmp   dialog.insert.keylist
        ;-------------------------------------------------------
        ; Show that FastMode is off
        ;-------------------------------------------------------
!       li    tmp0,txt.keys.insert
        ;-------------------------------------------------------
        ; Show dialog
        ;-------------------------------------------------------
dialog.insert.keylist:
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
dialog.insert.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller                                         
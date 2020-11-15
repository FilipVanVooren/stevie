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
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.load:
        ;-------------------------------------------------------
        ; Show dialog "unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   dialog.load.setup
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
dialog.load.setup:        
        li    tmp0,id.dialog.load
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.load
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message, do input prompt

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

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
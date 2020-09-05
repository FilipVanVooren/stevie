* FILE......: dialog.load.asm
* Purpose...: Dialog "Load file"

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Open DV80 file
*//////////////////////////////////////////////////////////////


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
        li    tmp0,id.dialog.load
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.load
        mov   tmp0,@cmdb.panhead    ; Header for dialog

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
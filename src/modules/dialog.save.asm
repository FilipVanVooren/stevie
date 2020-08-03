* FILE......: dialog.save.asm
* Purpose...: Dialog "Save file"

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Save DV80 file
*//////////////////////////////////////////////////////////////


***************************************************************
* dialog.save
* Open Dialog for saving file
***************************************************************
* b @dialog.save
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
dialog.save:
        li    tmp0,id.dialog.save
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.save
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.save
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.save
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
* FILE......: dialog.file.unsaved.asm
* Purpose...: Dialog "Unsaved changes"

*//////////////////////////////////////////////////////////////
*      Stevie Editor - Unsaved changes in editor buffer
*//////////////////////////////////////////////////////////////


***************************************************************
* dialog.unsaved
* Open Dialog "Unsaved changes"
***************************************************************
* b @dialog.unsaved
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
dialog.unsaved:
        li    tmp0,id.dialog.unsaved
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.unsaved
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.unsaved
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.unsaved
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
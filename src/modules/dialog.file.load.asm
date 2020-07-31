* FILE......: dialog.file.load.asm
* Purpose...: Dialog "Load file"

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Open DV80 file
*//////////////////////////////////////////////////////////////


***************************************************************
* dialog.load_dv80
* Open Dialog for loading DV 80 file
***************************************************************
* b @dialog.load_dv80
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
dialog.loaddv80:
        li    tmp0,id.dialog.loaddv80
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.loaddv80
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.hint.loaddv80
        mov   tmp0,@cmdb.panhint    ; Hint line in dialog

        li    tmp0,txt.keys.loaddv80
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
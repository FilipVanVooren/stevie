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
        li    tmp0,txt.cmdb.loaddv80
        mov   tmp0,@cmdb.pantitle   ; Title for dialog

        li    tmp0,txt.cmdb.hintdv80
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        b    @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
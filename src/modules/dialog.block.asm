* FILE......: dialog.block.asm
* Purpose...: Dialog "Block move/copy/delete"

***************************************************************
* dialog.block
* Open Dialog for block delete/move/copy
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
dialog.block:
        li    tmp0,id.dialog.block
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.block
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.block
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,txt.hint.block
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.block
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor 

        b     @edkey.action.cmdb.show
                                    ; Show dialog in CMDB pane        
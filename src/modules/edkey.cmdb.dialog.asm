* FILE......: edkey.cmdb.dialog.asm
* Purpose...: Dialog related actions in command buffer pane.



*---------------------------------------------------------------
* Proceed with action
*---------------------------------------------------------------
edkey.action.cmdb.proceed:
        ;-------------------------------------------------------
        ; Ignore changes if in "Unsaved changes" dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.unsaved
        c     @cmdb.dialog,tmp0
        jne   edkey.action.cmdb.proceed.exit
        ;-------------------------------------------------------
        ; Continue to file load dialog
        ;-------------------------------------------------------
        b     @dialog.load          ; Show "Load DV80 file" dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.proceed.exit:
        b     @hook.keyscan.bounce  ; Back to editor main


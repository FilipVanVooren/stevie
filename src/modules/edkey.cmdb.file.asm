* FILE......: edkey.cmdb.fíle.asm
* Purpose...: File related actions in command buffer pane.


*---------------------------------------------------------------
* Load DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.loadfile:
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        li    tmp0,cmdb.cmdlen      ; Length-prefixed command string
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           string "dev.filename"
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.loadfile.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
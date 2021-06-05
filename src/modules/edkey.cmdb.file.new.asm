* FILE......: edkey.cmdb.fíle.new.asm
* Purpose...: Load file from command buffer pane.

*---------------------------------------------------------------
* New DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.file.new:
        ;-------------------------------------------------------
        ; New file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane
        bl    @tv.reset             ; Reset editor      
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.file.new.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
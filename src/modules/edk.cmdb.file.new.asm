* FILE......: edk.cmdb.file.new.asm
* Purpose...: New file from command buffer pane

*---------------------------------------------------------------
* New file
*---------------------------------------------------------------
edk.act.cmdb.file.new:
        ;-------------------------------------------------------
        ; New file
        ;-------------------------------------------------------
        .pushregs 0                 ; Push return address and registers on stack        
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0       ; Editor dirty?
        jeq   !                     ; No, skip "Unsaved changes"

        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
!       bl    @pane.cmdb.hide       ; Hide CMDB pane
        bl    @fm.newfile           ; New file in editor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edk.act.cmdb.file.new.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edk.act.top     ; Goto 1st line in editor buffer
* FILE......: edkey.cmdb.fíle.new.asm
* Purpose...: New file from command buffer pane

*---------------------------------------------------------------
* New DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.file.new:
        ;-------------------------------------------------------
        ; New file
        ;-------------------------------------------------------
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0       ; Editor dirty?
        jeq   !                     ; No, skip "Unsaved changes"

        bl    @dialog.unsaved       ; Show dialog
        jmp   edkey.action.cmdb.file.new.exit
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
!       bl    @pane.cmdb.hide       ; Hide CMDB pane
        bl    @fm.newfile           ; New file in editor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.file.new.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     @edkey.action.top     ; Goto 1st line in editor buffer 
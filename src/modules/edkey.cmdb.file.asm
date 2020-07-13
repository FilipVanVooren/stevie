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
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, load file
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        bl    @pane.errline.show    ; Show error line

        bl    @pane.show_hint
              byte 28,0
              data txt.io.nofile

        jmp   edkey.action.cmdb.loadfile.exit
        ;-------------------------------------------------------
        ; Load specified file
        ;-------------------------------------------------------
!       bl    @cpym2m
              data cmdb.cmdlen,heap.top,80
                                    ; Copy filename from command line to buffer

        li    tmp0,heap.top         ; 1st line in heap
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           device/filename string
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.loadfile.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
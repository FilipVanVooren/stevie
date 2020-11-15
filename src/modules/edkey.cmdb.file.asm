* FILE......: edkey.cmdb.fíle.asm
* Purpose...: File related actions in command buffer pane.

*---------------------------------------------------------------
* Load or save DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.loadsave:
        ;-------------------------------------------------------
        ; Load or save file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, prepare for load/save
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        bl    @pane.errline.show    ; Show error line

        bl    @pane.show_hint
              byte 28,0
              data txt.io.nofile

        jmp   edkey.action.cmdb.loadsave.exit
        ;-------------------------------------------------------
        ; Prepare for loading or saving file
        ;-------------------------------------------------------
!       sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdlen,heap.top,80
                                    ; Copy filename from command line to buffer

        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.load   ; Dialog is "Load DV80 file" ?
        jeq   edkey.action.cmdb.load.loadfile

        ci    tmp0,id.dialog.save   ; Dialog is "Save DV80 file" ?
        jeq   edkey.action.cmdb.load.savefile
        ;-------------------------------------------------------
        ; Load specified file
        ;-------------------------------------------------------
edkey.action.cmdb.load.loadfile:
        li    tmp0,heap.top         ; 1st line in heap
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           device/filename string
        jmp   edkey.action.cmdb.loadsave.exit
        ;-------------------------------------------------------
        ; Save specified file
        ;-------------------------------------------------------
edkey.action.cmdb.load.savefile:
        li    tmp0,heap.top         ; 1st line in heap
        bl    @fm.savefile          ; Save DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           device/filename string
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.loadsave.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
* FILE......: edkey.cmdb.fíle.save.asm
* Purpose...: File related actions in command buffer pane.

*---------------------------------------------------------------
* Save DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.save:
        ;-------------------------------------------------------
        ; Save file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, prepare for save
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        bl    @pane.errline.show    ; Show error line

        bl    @pane.show_hint
              byte pane.botrow-1,0
              data txt.io.nofile

        jmp   edkey.action.cmdb.save.exit
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
!       sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdlen,heap.top,80
                                    ; Copy filename from command line to buffer
        ;-------------------------------------------------------
        ; Pass filename as parm1
        ;-------------------------------------------------------
        li    tmp0,heap.top         ; 1st line in heap
        mov   tmp0,@parm1        
        ;-------------------------------------------------------
        ; Save all lines in editor buffer?
        ;-------------------------------------------------------
        mov   @edb.block.m2,tmp0    ; Marker M2 set?
        jeq   edkey.action.cmdb.save.all
                                    ; No, so save all lines in editor buffer
        ;-------------------------------------------------------
        ; Only save code block M1-M2
        ;-------------------------------------------------------
        mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
        dec   @parm2                ; /

        mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1

        jmp   edkey.action.cmdb.save.file
        ;-------------------------------------------------------
        ; Save all lines in editor buffer
        ;-------------------------------------------------------
edkey.action.cmdb.save.all:
        clr   @parm2                ; First line to save
        mov   @edb.lines,@parm3     ; Last line to save
        ;-------------------------------------------------------
        ; Save file
        ;-------------------------------------------------------
edkey.action.cmdb.save.file:
        bl    @fm.savefile          ; Save DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; |            device/filename string
                                    ; | i  parm2 = First line to save (base 0)
                                    ; | i  parm3 = Last line to save  (base 0)
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.save.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
* FILE......: edkey.cmdb.fíle.ins.asm
* Purpose...: Insert file from command buffer pane.

*---------------------------------------------------------------
* Insert DV 80 file
*---------------------------------------------------------------
edkey.action.cmdb.ins:
        ;-------------------------------------------------------
        ; Insert file at current line in editor buffer
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, prepare for load
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        bl    @pane.errline.show    ; Show error line

        bl    @pane.show_hint
              byte pane.botrow-1,0
              data txt.io.nofile

        jmp   edkey.action.cmdb.ins.exit
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
        ; Insert file at line
        ;-------------------------------------------------------
edkey.action.cmdb.ins.file:
        ;-------------------------------------------------------
        ; Get line
        ;-------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @outparm1,@parm2
        inc   @parm2                ; Insert file starting at next line
        ;-------------------------------------------------------
        ; Get device/filename
        ;-------------------------------------------------------
        li    tmp0,heap.top         ; 1st line in heap
        mov   tmp0,@parm1
        ;-------------------------------------------------------
        ; Insert file
        ;-------------------------------------------------------
        bl    @fm.insertfile        ; Insert DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; |            device/filename string
                                    ; | i  parm2 = Line number to load file at
        ;-------------------------------------------------------
        ; Refresh frame buffer
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Same actions as when closing CMDB pane
                                    ; (blink cursor, focus fb, etc)

        seto  @fb.dirty             ; Refresh frame buffer
        seto  @edb.dirty            ; Editor buffer dirty

        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.ins.exit:
        b     @edkey.action.home    ; Stay on current line
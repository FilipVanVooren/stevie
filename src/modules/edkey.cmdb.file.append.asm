* FILE......: edkey.cmdb.fíle.append.asm
* Purpose...: Append file from command buffer pane.

*---------------------------------------------------------------
* Append file
*---------------------------------------------------------------
edkey.action.cmdb.append:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @fb.topline,*stack    ; Push line number of fb top row
        ;-------------------------------------------------------
        ; Append file after last line in editor buffer
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, prepare for load
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

        jmp   edkey.action.cmdb.append.exit
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
!       sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdall,heap.top,80
                                    ; Copy filename from command line to buffer
        ;-------------------------------------------------------
        ; Pass filename as parm1
        ;-------------------------------------------------------
        li    tmp0,heap.top         ; 1st line in heap
        mov   tmp0,@parm1        
        ;-------------------------------------------------------
        ; Append file
        ;-------------------------------------------------------
edkey.action.cmdb.append.file:
        mov   @edb.lines,@parm2     ; \ Append file after last line in
                                    ; / editor buffer (base 0 offset)
        ;-------------------------------------------------------
        ; Get device/filename
        ;-------------------------------------------------------
        li    tmp0,heap.top         ; 1st line in heap
        mov   tmp0,@parm1        
        ;-------------------------------------------------------
        ; Append file
        ;-------------------------------------------------------
        li    tmp0,id.file.appendfile
        mov   tmp0,@parm3           ; Set work mode

        bl    @fm.insertfile        ; Insert DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; |            device/filename string
                                    ; | i  parm2 = Line number to load file at
                                    ; / i  parm3 = Work mode
        ;-------------------------------------------------------
        ; Refresh frame buffer
        ;-------------------------------------------------------
        seto  @fb.dirty             ; Refresh frame buffer
        seto  @edb.dirty            ; Editor buffer dirty

        mov   @fb.topline,@parm1
        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.append.exit:
        mov   *stack+,@parm1        ; Pop top row
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer

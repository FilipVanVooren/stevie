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
        ; Read directory if last character is '.'
        ;-------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length-byte prefix of filename
        srl   tmp0,8                ; MSB to LSB
        ai    tmp0,cmdb.cmdall      ; Add pointer base address to offset   
        movb  *tmp0,tmp0            ; Get character into MSB
        srl   tmp0,8                ; MSB to LSB
        ci    tmp0,46               ; Is it a '.' ?
        jne   edkey.action.cmdb.append.checklen
                                    ; No, check filename length
        ;-------------------------------------------------------
        ; Read directory and exit
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmdall      ; \ Pass filename as parm1
        mov   tmp0,@parm1           ; /

        clr   @parm3                ; Show filebrowser after reading directory

        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; |          (ignored if parm1 set)
                                    ; / @parm3 = Skip filebrowser flag
        jmp   edkey.action.cmdb.append.exit
        ;-------------------------------------------------------
        ; Check filename length
        ;-------------------------------------------------------
edkey.action.cmdb.append.checklen:        
        bl    @cmdb.cmd.getlength            ; Get length of current command
        mov   @outparm1,tmp0                 ; Length == 0 ?
        jeq   edkey.action.cmdb.append.exit  ; Yes, exit early
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
        sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdall,heap.top,80
                                    ; Copy filename from command line to buffer

        bl    @pane.cmdb.hide       ; Hide CMDB pane                                    
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

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

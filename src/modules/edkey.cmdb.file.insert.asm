* FILE......: edkey.cmdb.fíle.insert.asm
* Purpose...: Insert file from command buffer pane.

*---------------------------------------------------------------
* Insert file
*---------------------------------------------------------------
edkey.action.cmdb.insert:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @fb.topline,*stack    ; Push line number of fb top row
        ;-------------------------------------------------------
        ; Exit early if last character is '.'
        ;-------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length-byte prefix of filename
        srl   tmp0,8                ; MSB to LSB
        ai    tmp0,cmdb.cmdall      ; Add pointer base address to offset   
        movb  *tmp0,tmp0            ; Get character into MSB
        srl   tmp0,8                ; MSB to LSB
        ci    tmp0,46               ; Is it a '.' ?
        jeq   edkey.action.cmdb.insert.exit
                                    ; No filename specified        
        ;-------------------------------------------------------
        ; Check filename length
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength              ; Get length of current command
        mov   @outparm1,tmp0                   ; Length == 0 ?
        jeq   edkey.action.cmdb.insert.exit    ; Yes, exit early
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
!       sla   tmp0,8               ; LSB to MSB 
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
        ; Insert file at line
        ;-------------------------------------------------------
edkey.action.cmdb.insert.file:
        ;-------------------------------------------------------
        ; Get line
        ;-------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @outparm1,@parm2      ; \ Line to insert file at is the editor
        inc   @parm2                ; / line where the cursor is at +1
        ;-------------------------------------------------------
        ; Get device/filename
        ;-------------------------------------------------------
        li    tmp0,heap.top         ; 1st line in heap
        mov   tmp0,@parm1
        ;-------------------------------------------------------
        ; Insert file
        ;-------------------------------------------------------
        li    tmp0,id.file.insertfile
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
edkey.action.cmdb.insert.exit:
        mov   *stack+,@parm1        ; Pop top row
        mov   *stack+,tmp0          ; Pop tmp0

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer

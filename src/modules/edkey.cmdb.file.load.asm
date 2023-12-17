* FILE......: edkey.cmdb.fíle.load.asm
* Purpose...: Load file from command buffer pane.

*---------------------------------------------------------------
* Load file
*---------------------------------------------------------------
edkey.action.cmdb.load:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0       
        ;-------------------------------------------------------
        ; Exit early if last character is '.'
        ;-------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length-byte prefix of filename
        srl   tmp0,8                ; MSB to LSB
        ai    tmp0,cmdb.cmdall      ; Add pointer base address to offset   
        movb  *tmp0,tmp0            ; Get character into MSB
        srl   tmp0,8                ; MSB to LSB
        ci    tmp0,46               ; Is it a '.' ?
        jeq   edkey.action.cmdb.load.exit
                                    ; No filename specified
        ;-------------------------------------------------------
        ; Check filename length
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength            ; Get length of current command
        mov   @outparm1,tmp0                 ; Length == 0 ?
        jeq   edkey.action.cmdb.load.exit    ; Yes, exit early
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
!       sla   tmp0,8                ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen     ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdlen,heap.top,80
                                    ; Copy filename from command line to buffer

        bl    @pane.cmdb.hide       ; Hide CMDB pane
        ;-------------------------------------------------------
        ; Special handling Master Catalog
        ;-------------------------------------------------------
        mov   @edb.special.file,tmp0  ; \ Master catalog previously open?
        ci    tmp0,id.special.mastcat ; / 

        jne   edkey.action.cmdb.load.file
                                    ; No, just load file

        mov   @fb.topline,@edb.bk.fb.topline
                                    ; Backup @fb.topline
        mov   @fb.row,@edb.bk.fb.row 
                                    ; Backup @fb.row                          

        clr   @edb.dirty            ; No confirmation, always load immediately.
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
edkey.action.cmdb.load.file:       
        clr   @edb.special.file     ; Reset special file flag
        clr   @tv.specmsg.ptr       ; Reset special message

        li    tmp0,heap.top         ; Pass filename as parm1
        mov   tmp0,@parm1           ; (1st line in heap)

        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.load.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.action.top     ; Goto 1st line in editor buffer 

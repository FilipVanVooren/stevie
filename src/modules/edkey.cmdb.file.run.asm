* FILE......: edkey.cmdb.file.run.asm
* Purpose...: Run EA5 program image

*---------------------------------------------------------------
* Run EA5 program image
********|*****|*********************|**************************
edkey.action.cmdb.file.run:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0       
        ;-------------------------------------------------------
        ; Read directory if last character is '.'
        ;-------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length-byte prefix of filename
        srl   tmp0,8                ; MSB to LSB
        ai    tmp0,cmdb.cmdall      ; Add pointer base address to offset   
        movb  *tmp0,tmp0            ; Get character into MSB
        srl   tmp0,8                ; MSB to LSB
        ci    tmp0,46               ; Is it a '.' ?
        jne   edkey.action.cmdb.file.run.checklen
                                    ; No, check filename length
        ;-------------------------------------------------------
        ; Read directory and exit
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmdall      ; \ Pass filename as parm1
        mov   tmp0,@parm1           ; /

        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; /          (ignored if parm1 set)
        jmp   edkey.action.cmdb.file.run.exit
        ;-------------------------------------------------------
        ; Check filename length
        ;-------------------------------------------------------
edkey.action.cmdb.file.run.checklen:        
        bl    @cmdb.cmd.getlength             ; Get length of current command
        mov   @outparm1,tmp0                  ; Length == 0 ?
        jeq   edkey.action.cmdb.file.run.exit ; Yes, exit early
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
        ; Load file
        ;-------------------------------------------------------
edkey.action.cmdb.file.run.ea5:       
        li    tmp0,heap.top         ; Pass filename as parm1
        mov   tmp0,@parm1           ; (1st line in heap)

        bl    @fm.run.ea5           ; Run EA5 program image
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.file.run.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11    
        b     @edkey.keyscan.hook.debounce 
                                    ; Back to editor main        

* FILE......: edkey.cmdb.cfg.clip.asm
* Purpose...: Configure clipboard

*---------------------------------------------------------------
* Configure clipboard
*---------------------------------------------------------------
edkey.action.cmdb.cfg.clip:
        ;-------------------------------------------------------
        ; Configure
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, set clipboard device and filename
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

        jmp   edkey.action.cmdb.cfg.clip.exit
        ;-------------------------------------------------------
        ; Set clipboard device and filename
        ;-------------------------------------------------------
!       sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Set length-prefix of command line string

        bl    @cpym2m
              data cmdb.cmdall,tv.clip.fname,80
                                    ; Copy filename from command line to buffer

        ;-------------------------------------------------------
        ; Show message 
        ;------------------------------------------------------- 
edkey.action.cmdb.cfg.clip.message:
        bl    @hchar
              byte 0,52,32,20       
              data EOL              ; Erase any previous message
              
        bl    @putat
              byte 0,52
              data txt.done.clipdev
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------          
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay           
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.cfg.clip.exit:
        b    @edkey.action.top      ; Goto 1st line in editor buffer 

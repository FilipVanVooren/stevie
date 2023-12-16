* FILE......: cmdb.cfg.fname.asm
* Purpose...: Configure filename

***************************************************************
* cmdb.cfg.fname
* Configure filename for clipboard, master catalog, ...
***************************************************************
* bl  @cmdb.cfg.fname
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to 80 bytes buffer for storing filename
* @parm2 = Pointer to oneshot message to display when done
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************

*---------------------------------------------------------------
* Configure filename
*---------------------------------------------------------------
cmdb.cfg.fname:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Configure
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jne   !                     ; No, continue
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

        jmp   cmdb.cfg.fname.exit   ; Exit
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
!       sla   tmp0,8                ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen     ; Set length-prefix of command line string

        li    tmp0,cmdb.cmdall      ; Source
        mov   @parm1,tmp1           ; Destination
        li    tmp2,80               ; Number of bytes to copy

        bl    @xpym2m               ; Copy filename from command line to buffer
                                    ; \ i  tmp0 = Source address
                                    ; | i  tmp1 = Destination address
                                    ; / i  tmp2 = Number of bytes to copy
        ;-------------------------------------------------------
        ; Show message 
        ;------------------------------------------------------- 
cmdb.cfg.fname.message:
        bl    @hchar
              byte 0,50,32,20       
              data EOL              ; Erase any previous message
              
        li    tmp0,52               ; y=0, x=52
        mov   tmp0,@wyx             ; Set cursor
        mov   @parm2,tmp1           ; Get string to display
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
cmdb.cfg.fname.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

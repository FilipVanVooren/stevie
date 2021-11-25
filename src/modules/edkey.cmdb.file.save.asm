* FILE......: edkey.cmdb.fíle.save.asm
* Purpose...: File related actions in command buffer pane.

*---------------------------------------------------------------
* Save file
*---------------------------------------------------------------
edkey.action.cmdb.save:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   @fb.topline,*stack    ; Push line number of fb top row
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
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

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
        c     @edb.block.m2,@w$ffff ; Marker M2 unset?        
        jeq   edkey.action.cmdb.save.all
                                    ; Yes, so save all lines in editor buffer
        ;-------------------------------------------------------
        ; Only save code block M1-M2
        ;-------------------------------------------------------
        mov   @edb.block.m1,@parm2  ; \ First line to save (base 0)
        dec   @parm2                ; /

        mov   @edb.block.m2,@parm3  ; Last line to save (base 0) + 1

        li    tmp0,id.file.saveblock
        jmp   edkey.action.cmdb.save.file
        ;-------------------------------------------------------
        ; Save all lines in editor buffer
        ;-------------------------------------------------------
edkey.action.cmdb.save.all:
        clr   @parm2                ; First line to save
        mov   @edb.lines,@parm3     ; Last line to save

        li    tmp0,id.file.savefile
        ;-------------------------------------------------------
        ; Save file
        ;-------------------------------------------------------
edkey.action.cmdb.save.file:
        mov   tmp0,@parm4           ; Set work mode

        bl    @fm.savefile          ; Save DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; |            device/filename string
                                    ; | i  parm2 = First line to save (base 0)
                                    ; | i  parm3 = Last line to save  (base 0)
                                    ; | i  parm4 = Work mode                                    
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.save.exit:
        mov   *stack+,@parm1        ; Pop top row
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
* FILE......: edkey.cmdb.file.run.asm
* Purpose...: Run EA5 program image

*---------------------------------------------------------------
* Run EA5 program image
********|*****|*********************|**************************
edkey.action.cmdb.file.run:
        ;-------------------------------------------------------
        ; Get filename
        ;-------------------------------------------------------
        sla   tmp0,8                ; LSB to MSB 
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
        b     @edkey.keyscan.hook.debounce 
                                    ; Back to editor main        

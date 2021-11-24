* FILE......: cmdb.cmd.set.asm
* Purpose...: Set command line

***************************************************************
* cmdb.cmd.set
* Set current command
***************************************************************
* bl @cmdb.cmd.set
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to string with command
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.set:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Clear command
        ;------------------------------------------------------
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80
        ;------------------------------------------------------
        ; Get string length
        ;------------------------------------------------------
        mov   @parm1,tmp0           
        movb  *tmp0+,tmp2           ; Get length byte
        srl   tmp2,8                ; Right align
        jgt   !
        ;------------------------------------------------------
        ; Assert: invalid length, we just exit here
        ;------------------------------------------------------
        jmp   cmdb.cmd.set.exit     ; No harm done
        ;------------------------------------------------------
        ; Copy string to command
        ;------------------------------------------------------
!       li   tmp1,cmdb.cmd          ; Destination
        bl   @xpym2m                ; Copy string
        ;------------------------------------------------------
        ; Put cursor at beginning of line
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,tmp0   
        inc   tmp0                  
        mov   tmp0,@cmdb.cursor     ; Position cursor        

        seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.set.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: cmdb.cmd.asm
* Purpose...: Stevie Editor - Command line

***************************************************************
* cmdb.cmd.clear
* Clear current command
***************************************************************
* bl @cmdb.cmd.clear
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.clear:
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
        ; Put cursor at beginning of line
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,tmp0   
        inc   tmp0                  
        mov   tmp0,@cmdb.cursor     ; Position cursor        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.clear.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* cmdb.cmdb.getlength
* Get length of current command
***************************************************************
* bl @cmdb.cmd.getlength
*--------------------------------------------------------------
* INPUT
* @cmdb.cmd
*--------------------------------------------------------------
* OUTPUT
* @outparm1
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.getlength:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Get length of null terminated string
        ;-------------------------------------------------------
        bl    @string.getlenc      ; Get length of C-style string
              data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
                                   ; | i  p1    = Termination character
                                   ; / o  waux1 = Length of string
        mov   @waux1,@outparm1     ; Save length of string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.getlength.exit:        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

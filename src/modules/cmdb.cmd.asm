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
        ;------------------------------------------------------
        ; Clear command
        ;------------------------------------------------------
        clr   @cmdb.cmdlen          ; Reset length 
        bl    @film                 ; Clear command
              data  cmdb.cmd,>00,80

        clr   @cmdb.column          ; Reset column
        ;------------------------------------------------------
        ; Put cursor at beginning of line
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,tmp0   
        inct  tmp0                  ; Skip ">" prompt
        mov   tmp0,@cmdb.cursor     ; Position cursor

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.clear.exit:        
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



***************************************************************
* cmdb.cmd.cursor_eol
* Set cursor at end of line
***************************************************************
* bl @cmdb.cmd.cursor_eol
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* @cmdb.cursor = New cursor position
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.cursor_eol:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;---------------------------------------------------------------
        ; Position cursor at end of input line
        ;---------------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; \ Get length of command line input
                                    ; | i   @cmdb.cmd = Pointer to prompt
                                    ; / o   @outparm1 = Length of prompt

        mov   @outparm1,tmp0        ; Length of prompt
        mov   tmp0,@cmdb.column     ; Save column position
        ;---------------------------------------------------------------
        ; Cursor position! Not the same as cmdb column, has offset
        ;---------------------------------------------------------------                
        ai    tmp0,3                ; Add offset + cursor after last char
        sla   tmp0,8                ; LSB TO MSB
        movb  tmp0,@cmdb.cursor + 1 ; Set cursor position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.cursor_eol.exit:        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller     

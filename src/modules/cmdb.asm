* FILE......: cmdb.asm
* Purpose...: Stevie Editor - Command Buffer module

*//////////////////////////////////////////////////////////////
*        Stevie Editor - Command Buffer implementation
*//////////////////////////////////////////////////////////////


***************************************************************
* cmdb.init
* Initialize Command Buffer
***************************************************************
* bl @cmdb.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,cmdb.top         ; \ Set pointer to command buffer
        mov   tmp0,@cmdb.top.ptr    ; /

        clr   @cmdb.visible         ; Hide command buffer 
        li    tmp0,4
        mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
        mov   tmp0,@cmdb.default    ; Set default command buffer size        

        clr   @cmdb.lines           ; Number of lines in cmdb buffer
        clr   @cmdb.dirty           ; Command buffer is clean
        ;------------------------------------------------------
        ; Clear command buffer
        ;------------------------------------------------------
        bl    @film
        data  cmdb.top,>00,cmdb.size 
                                    ; Clear it all the way
cmdb.init.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller







***************************************************************
* cmdb.refresh
* Refresh command buffer content
***************************************************************
* bl @cmdb.refresh
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.refresh:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Dump Command buffer content
        ;------------------------------------------------------
        mov   @wyx,@cmdb.yxsave     ; Save YX position
        mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt

        inc   @wyx                  ; X +1 for prompt

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.                              
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        li    tmp1,cmdb.cmd         ; Address of current command
        li    tmp2,1*79             ; Command length

        bl    @xpym2v               ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Number of bytes to copy       
        ;------------------------------------------------------
        ; Show command buffer prompt
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,@wyx
        bl    @putstr
              data txt.cmdb.prompt

        mov   @cmdb.yxsave,@fb.yxsave 
        mov   @cmdb.yxsave,@wyx        
                                    ; Restore YX position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.refresh.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller





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
              
cmdb.cmd.clear.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller






***************************************************************
* cmdb.getlength
* Get length of current command
***************************************************************
* bl @cmdb.getlength
*--------------------------------------------------------------
* INPUT
* @cmdb.cmd
*--------------------------------------------------------------
* OUTPUT
* @cmdb.cmdlen  (Length in MSB)
* @outparm1     (Length in LSB)
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.cmd.getlength:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Get length of null terminated string
        ;-------------------------------------------------------
        bl    @string.getlenc      ; Get length of C-style string
              data cmdb.cmd,0      ; \ i  p0    = Pointer to C-style string
                                   ; | i  p1    = Termination character
                                   ; / o  waux1 = Length of string
        mov   @waux1,tmp0          
        mov   tmp0,@outparm1       ; Save length of string
        sla   tmp0,8               ; LSB to MSB 
        movb  tmp0,@cmdb.cmdlen    ; Save length of string        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.cmd.getlength.exit:        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

        
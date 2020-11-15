* FILE......: cmdb.refresh.asm
* Purpose...: Stevie Editor - Command buffer

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
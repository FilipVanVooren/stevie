* FILE......: cmdb.refresh_prompt.asm
* Purpose...: Stevie Editor - Command buffer

***************************************************************
* cmdb.refresh_prompt
* Refresh command buffer prompt
***************************************************************
* bl @cmdb.refresh_prompt
*--------------------------------------------------------------
* INPUT
* @cmdb.yxprompt = YX position command line prompt
* @cmdb.cmd      = Current prompt
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.refresh_prompt:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Show command buffer prompt
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,@wyx
        bl    @putstr
              data txt.cmdb.prompt  ; Draw prompt ">"        
        ;------------------------------------------------------
        ; Dump Command buffer content
        ;------------------------------------------------------
        mov   @cmdb.yxprompt,@wyx   ; Screen position of command line prompt
        inc   @wyx                  ; Skip '>' character

        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        li    tmp1,cmdb.cmd         ; Address of current command
        li    tmp2,1*76             ; Command length

        bl    @xpym2v               ; \ Copy CPU memory to VDP memory
                                    ; | i  tmp0 = VDP target address
                                    ; | i  tmp1 = RAM source address
                                    ; / i  tmp2 = Number of bytes to copy
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.refresh_prompt.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

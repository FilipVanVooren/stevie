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
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
cmdb.refresh_prompt:
        .pushregs 2                 ; Push registers and return address on stack
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
        .popregs 2                  ; Pop registers and return to caller        

* FILE......: cmdb.asm
* Purpose...: Stevie Editor - Command Buffer module

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
        .pushregs 1                 ; Push registers and return address on stack
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,cmdb.top         ; \ Set pointer to command buffer
        mov   tmp0,@cmdb.top.ptr    ; /

        clr   @cmdb.visible         ; Hide command buffer
        li    tmp0,cmdb.rows
        mov   tmp0,@cmdb.scrrows    ; Set current command buffer size
        mov   tmp0,@cmdb.default    ; Set default command buffer size

        clr   @cmdb.lines           ; Number of lines in cmdb buffer
        clr   @cmdb.dirty           ; Command buffer is clean
        clr   @cmdb.action.ptr      ; Reset action to execute pointer
        seto  @cmdb.fb.yxsave       ; Reset (removes "write protection")        
        ;------------------------------------------------------
        ; Calculate VDP address of CMDB top row (TAT!)
        ;------------------------------------------------------
        li    tmp0,pane.botrow      ; \
        s     @cmdb.scrrows,tmp0    ; | pos = Y * (columns per row)
        mpy   @wcolmn,tmp0          ; | result is in tmp1
        mov   tmp1,tmp0             ; | Get result
        ai    tmp0,vdp.tat.base     ; | Add VDP TAT base address
        mov   tmp0,@cmdb.vdptop     ; /
        ;------------------------------------------------------
        ; Clear command buffer
        ;------------------------------------------------------
        bl    @film
              data  cmdb.top,>00,cmdb.size
                                    ; Clear it all the way
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
cmdb.init.exit:
        .popregs 1                  ; Pop registers and return to caller
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
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
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
        clr   @cmdb.action.ptr      ; Reset action to execute pointer
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
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

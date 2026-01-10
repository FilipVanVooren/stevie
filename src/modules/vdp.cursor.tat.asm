* FILE......: vdp.cursor.tat.asm
* Purpose...: Set VDP cursor shape (character version)

***************************************************************
* vdp.cursor.tat
* Set VDP cursor shape (character version)
***************************************************************
* bl @vdp.cursor.tat
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
vdp.cursor.tat:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Get pane with focus
        ;------------------------------------------------------
        mov   @tv.pane.focus,tmp0     ; Get pane with focus
        ci    tmp0,pane.focus.fb
        jeq   vdp.cursor.tat.cur.fb   ; Frame buffer has focus
        ci    tmp0,pane.focus.cmdb
        jeq   vdp.cursor.tat.cur.cmdb ; CMDB buffer has focus
        ;------------------------------------------------------
        ; Assert failed. Invalid value
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Halt system.
        ;------------------------------------------------------
        ; CMDB buffer has focus, position CMDB cursor
        ;------------------------------------------------------
vdp.cursor.tat.cur.cmdb:
        bl    @vdp.cursor.tat.cmdb  ; Show cursor
        jmp   vdp.cursor.tat.exit   ; Exit
        ;------------------------------------------------------
        ; Frame buffer has focus, position FB cursor
        ;------------------------------------------------------
vdp.cursor.tat.cur.fb:
        bl     @vdp.cursor.tat.fb   ; Show cursor
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.tat.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

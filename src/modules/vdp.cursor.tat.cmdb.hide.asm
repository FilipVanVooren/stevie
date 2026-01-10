* FILE......: vdp.cursor.cmdb.tat.hide.asm
* Purpose...: Hide VDP cursor

***************************************************************
* vdp.cursor.tat.cmdb.hide
* Hide VDP cursor
***************************************************************
* bl @vdp.cursor.tat.cmdb.hide
*--------------------------------------------------------------
* INPUT
* @cmdb.cursor    = New Cursor position
* cmdb.prevcursor = Old cursor position
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
vdp.cursor.tat.cmdb.hide:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Hide CMDB cursor
        ;------------------------------------------------------
        mov   @cmdb.prevcursor,tmp0 ; Get previous cursor position
        jne   !
        mov   @cmdb.cursor,tmp0
        mov   tmp0,@cmdb.prevcursor

!       dect  stack                 ; \ Push cursor position
        mov   @wyx,*stack           ; /

        mov   tmp0,@wyx             ; Set cursor position

        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address

        ai    tmp0,vdp.tat.base     ; Add TAT base
        mov   @tv.cmdb.color,tmp1   ; Get CMDB color

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write 

        mov   *stack+,@wyx          ; Pop cursor position
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.tat.cmdb.hide.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

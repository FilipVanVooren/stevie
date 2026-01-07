* FILE......: vdp.cursor.cmdb.tat.asm
* Purpose...: Set VDP cursor shape (character version)

***************************************************************
* vdp.cursor.tat.cmdb
* Set VDP cursor shape (character version)
***************************************************************
* bl @vdp.cursor.tat.cmdb
*--------------------------------------------------------------
* INPUT
* @cmdb.cursor     = New Cursor position
* @cmdb.prevcursor = Old cursor position
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
vdp.cursor.tat.cmdb:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack        
        mov   tmp2,*stack           ; Push tmp2        
        ;------------------------------------------------------
        ; Hide CMDB cursor
        ;------------------------------------------------------
        bl    @vdp.cursor.tat.cmdb.hide
                                    ; Hide CMDB cursor
                                    ; \ i @cmdb.cursor     = New Cursor position
                                    ; / i @cmdb.prevcursor = Old cursor position
        ;------------------------------------------------------
        ; Check if cursor needs to be shown
        ;------------------------------------------------------
        inv   @fb.curtoggle            ; Flip cursor shape flag
        jeq   vdp.cursor.tat.cmdb.show ; Show CMDB cursor
        jmp   vdp.cursor.tat.cmdb.exit ; Exit
        ;------------------------------------------------------
        ; Show cursor
        ;------------------------------------------------------                
vdp.cursor.tat.cmdb.show:
        mov   @cmdb.cursor,@wyx
        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
        ai    tmp0,vdp.tat.base     ; Add TAT base
        ;------------------------------------------------------
        ; Dump cursor color to TAT
        ;------------------------------------------------------        
        li    tmp1,>000f
        mov   tmp1,tmp2             ; \ 
        andi  tmp2,>000f            ; | LSB dup low nibble to high-nibble
        sla   tmp1,4                ; | Solid cursor FG/BG 
        soc   tmp2,tmp1             ; /

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write
                                    
        mov   @cmdb.cursor,@cmdb.prevcursor
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.tat.cmdb.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

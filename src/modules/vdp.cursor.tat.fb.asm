* FILE......: vdp.cursor.fb.tat.asm
* Purpose...: Set VDP cursor shape (character version)

***************************************************************
* vdp.cursor.fb.tat
* Set VDP cursor shape (character version)
***************************************************************
* bl @vdp.cursor.fb.tat
*--------------------------------------------------------------
* INPUT
* @wyx           = New Cursor position
* @fb.prevcursor = Old cursor position
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
vdp.cursor.fb.tat:
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
        ; Get previous cursor position
        ;------------------------------------------------------
        mov   @fb.prevcursor,tmp0    ; Get previous cursor position
        ai    tmp0,>0100             ; Add topline
        mov   @tv.ruler.visible,tmp1
        jeq   vdp.cursor.fb.tat.hide ; No ruler visible
        ai    tmp0,>0100             ; Add ruler line
        ;------------------------------------------------------
        ; Hide cursor on previous position
        ;------------------------------------------------------
vdp.cursor.fb.tat.hide:
        dect  stack                 ; \ Push cursor position
        mov   @wyx,*stack           ; /
        mov   tmp0,@wyx             ; Set cursor position

        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address

        ai    tmp0,vdp.tat.base     ; Add TAT base
        mov   @tv.color,tmp1        ; Get text color
        srl   tmp1,8                ; MSB to LSB

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write 

        mov   *stack+,@wyx          ; Pop cursor position
        mov   @wyx,@fb.prevcursor   ; Update cursor position
        ;------------------------------------------------------
        ; Check if cursor needs to be shown
        ;------------------------------------------------------
        inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   vdp.cursor.fb.tat.show ; Show FB cursor
        jmp   vdp.cursor.fb.tat.exit ; Exit
        ;------------------------------------------------------
        ; Show cursor
        ;------------------------------------------------------
vdp.cursor.fb.tat.show:
        mov   @tv.ruler.visible,tmp0
        jeq   vdp.cursor.fb.tat.show.noruler
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler visible
        ;------------------------------------------------------
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0200            ; Topline + ruler adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        jmp   vdp.cursor.fb.tat.dump
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler hidden
        ;------------------------------------------------------
vdp.cursor.fb.tat.show.noruler:
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0100            ; Topline adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        ;------------------------------------------------------
        ; Calculate VDP address
        ;------------------------------------------------------
vdp.cursor.fb.tat.dump:        
        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
        ai    tmp0,vdp.tat.base     ; Add TAT base
        ;------------------------------------------------------
        ; Dump cursor color to TAT
        ;------------------------------------------------------        
        mov   @tv.curcolor,tmp1     ; Get cursor color
        mov   tmp1,tmp2             ; \ 
        andi  tmp2,>000f            ; | LSB dup low nibble to high-nibble
        sla   tmp1,4                ; | Solid cursor FG/BG 
        soc   tmp2,tmp1             ; /

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.fb.tat.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

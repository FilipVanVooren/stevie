* FILE......: vdp.cursor.char.asm
* Purpose...: Set VDP cursor shape (character version)

***************************************************************
* vdp.cursor.char
* Set VDP cursor shape (character version)
***************************************************************
* bl @vdp.cursor.char
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
vdp.cursor.char:
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
        ; Get pane with focus
        ;------------------------------------------------------
        mov   @tv.pane.focus,tmp0   ; Get pane with focus

        ci    tmp0,pane.focus.fb
        jeq   vdp.cursor.char.fb    ; Frame buffer has focus

        ci    tmp0,pane.focus.cmdb
        jeq   vdp.cursor.char.cmdb  ; CMDB buffer has focus
        ;------------------------------------------------------
        ; Assert failed. Invalid value
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Halt system.
        ;------------------------------------------------------
        ; CMDB buffer has focus, position CMDB cursor
        ;------------------------------------------------------
vdp.cursor.char.cmdb:
        mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   vdp.cursor.char.dump  ; Show CMDB cursor
        ;------------------------------------------------------
        ; Hide CMDB cursor
        ;------------------------------------------------------
vdp.cursor.char.cmdb.hide:
        seto  @cmdb.dirty
        jmp   vdp.cursor.char.exit
        ;------------------------------------------------------
        ; Frame buffer has focus, position FB cursor
        ;------------------------------------------------------
vdp.cursor.char.fb:        
        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   vdp.cursor.char.fb.visible
                                    ; Show FB cursor
        ;------------------------------------------------------
        ; Hide FB cursor
        ;------------------------------------------------------
        seto  @fb.dirty             ; Trigger refresh
        jmp   vdp.cursor.char.exit
        ;------------------------------------------------------
        ; Show FB cursor
        ;------------------------------------------------------
vdp.cursor.char.fb.visible:
        mov   @tv.ruler.visible,tmp0
        jeq   vdp.cursor.char.fb.visible.noruler
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler visible
        ;------------------------------------------------------
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0200            ; Topline + ruler adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        jmp   vdp.cursor.char.dump
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler hidden
        ;------------------------------------------------------
vdp.cursor.char.fb.visible.noruler:
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0100            ; Topline adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        ;------------------------------------------------------
        ; Dump cursor to VDP
        ;------------------------------------------------------
vdp.cursor.char.dump:        
        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address

        li    tmp1,26               ; Cursor character

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.char.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

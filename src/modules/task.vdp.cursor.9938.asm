* FILE......: task.vdp.cursor.9938.asm
* Purpose...: VDP cursor shape (9938 version)

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   @wyx,*stack           ; Push cursor position

        mov   @wyx,tmp0
        ai    tmp0,>0100
        mov   tmp0,@wyx
        ;------------------------------------------------------
        ; Toggle cursor
        ;------------------------------------------------------
        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   task.vdp.cursor.visible
        ;------------------------------------------------------
        ; Hide cursor (show character behind cursor)
        ;------------------------------------------------------
        seto  @fb.dirty             ; Refresh frame buffer
        jmp   task.vdp.cursor.exit
        ;------------------------------------------------------
        ; Show cursor
        ;------------------------------------------------------
task.vdp.cursor.visible:
        li    tmp1,26               ; Cursor
        ;------------------------------------------------------
        ; Dump byte to VDP
        ;------------------------------------------------------
task.vdp.cursor.dump:        
        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP write address

        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task
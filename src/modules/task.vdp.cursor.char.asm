* FILE......: task.vdp.cursor.char.asm
* Purpose...: VDP cursor shape (character version)

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
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Get pane with focus
        ;------------------------------------------------------
        mov   @tv.pane.focus,tmp0   ; Get pane with focus

        ci    tmp0,pane.focus.fb
        jeq   task.vdp.cursor.fb    ; Frame buffer has focus

        ci    tmp0,pane.focus.cmdb
        jeq   task.vdp.cursor.cmdb  ; CMDB buffer has focus
        ;------------------------------------------------------
        ; Assert failed. Invalid value
        ;------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Halt system.
        ;------------------------------------------------------
        ; CMDB buffer has focus, position CMDB cursor
        ;------------------------------------------------------
task.vdp.cursor.cmdb:
        mov   @cmdb.cursor,@wyx     ; Position cursor in CMDB pane
        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   task.vdp.cursor.dump  ; Show CMDB cursor
        ;------------------------------------------------------
        ; Hide CMDB cursor
        ;------------------------------------------------------
task.vdp.cursor.cmdb.hide:
        seto  @cmdb.dirty
        jmp   task.vdp.cursor.exit
        ;------------------------------------------------------
        ; Frame buffer has focus, position FB cursor
        ;------------------------------------------------------
task.vdp.cursor.fb:        
        inv   @fb.curtoggle         ; Flip cursor shape flag
        jeq   task.vdp.cursor.fb.visible
                                    ; Show FB cursor
        ;------------------------------------------------------
        ; Hide FB cursor
        ;------------------------------------------------------
        seto  @fb.dirty             ; Trigger refresh
        jmp   task.vdp.cursor.exit
        ;------------------------------------------------------
        ; Show FB cursor
        ;------------------------------------------------------
task.vdp.cursor.fb.visible:
        mov   @tv.ruler.visible,tmp0
        jeq   task.vdp.cursor.fb.visible.noruler
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler visible
        ;------------------------------------------------------
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0200            ; Topline + ruler adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        jmp   task.vdp.cursor.dump
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler hidden
        ;------------------------------------------------------
task.vdp.cursor.fb.visible.noruler:
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0100            ; Topline adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        ;------------------------------------------------------
        ; Dump cursor to VDP
        ;------------------------------------------------------
task.vdp.cursor.dump:        
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
task.vdp.cursor.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task
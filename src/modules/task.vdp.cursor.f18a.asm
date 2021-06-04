* FILE......: task.vdp.cursor.f18a.asm
* Purpose...: VDP sprite cursor shape (F18a version)

***************************************************************
* Task - Update cursor shape (blink)
********|*****|*********************|**************************
task.vdp.cursor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle cursor
        ;------------------------------------------------------
        inv   @fb.curtoggle         ; Flip cursor shape flag        
        jeq   task.vdp.cursor.visible
        ;------------------------------------------------------
        ; Hide cursor
        ;------------------------------------------------------  
        clr   tmp0      
        movb  tmp0,@ramsat+3        ; Hide cursor
        jmp   task.vdp.cursor.copy.sat
                                    ; Update VDP SAT and exit task
        ;------------------------------------------------------
        ; Show cursor
        ;------------------------------------------------------                                    
task.vdp.cursor.visible:
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;------------------------------------------------------
        ; Copy SAT
        ;------------------------------------------------------
task.vdp.cursor.copy.sat:        
        bl    @cpym2v               ; Copy sprite SAT to VDP
              data sprsat,ramsat,4  ; \ i  p0 = VDP destination
                                    ; | i  p1 = ROM/RAM source
                                    ; / i  p2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
task.vdp.cursor.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     @slotok               ; Exit task
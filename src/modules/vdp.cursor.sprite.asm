* FILE......: vdp.cursor.sprite.asm
* Purpose...: VDP sprite cursor shape (sprite version)

***************************************************************
* vdp.cursor.sprite
* Set VDP cursor shape (sprite version)
***************************************************************
* bl @vdp.cursor.sprite
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
vdp.cursor.sprite:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Toggle cursor
        ;------------------------------------------------------
        inv   @fb.curtoggle         ; Flip cursor shape flag        
        jeq   vdp.cursor.sprite.visible
        ;------------------------------------------------------
        ; Hide cursor
        ;------------------------------------------------------  
        clr   tmp0      
        movb  tmp0,@ramsat+3        ; Hide cursor
        jmp   vdp.cursor.sprite.copy.sat
                                    ; Update VDP SAT and exit task
        ;------------------------------------------------------
        ; Show cursor
        ;------------------------------------------------------                                    
vdp.cursor.sprite.visible:
        mov   @tv.curshape,@ramsat+2
                                    ; Get cursor shape and color
        ;------------------------------------------------------
        ; Copy SAT
        ;------------------------------------------------------
vdp.cursor.sprite.copy.sat:        
        bl    @cpym2v               ; Copy sprite SAT to VDP
              data sprsat,ramsat,4  ; \ i  p0 = VDP destination
                                    ; | i  p1 = ROM/RAM source
                                    ; / i  p2 = Number of bytes to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
vdp.cursor.sprite.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

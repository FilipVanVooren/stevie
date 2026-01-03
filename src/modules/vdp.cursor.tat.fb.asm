* FILE......: vdp.cursor.tat.fb.asm
* Purpose...: Set VDP cursor shape (character version)



***************************************************************
* vdp.cursor.tat.fb
* Set VDP cursor shape (character version)
***************************************************************
* bl @vdp.cursor.tat.fb
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
vdp.cursor.tat.fb:
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
        jeq   vdp.cursor.tat.fb.hide ; No ruler visible
        ai    tmp0,>0100             ; Add ruler line
        ;------------------------------------------------------
        ; Step 1: Hide cursor on previous position
        ;------------------------------------------------------
vdp.cursor.tat.fb.hide:
        dect  stack                 ; \ Push cursor position
        mov   @wyx,*stack           ; /
        mov   tmp0,@wyx             ; Set cursor position

        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
        ai    tmp0,vdp.tat.base     ; Add TAT base
        ;------------------------------------------------------
        ; Determine background color of cursor
        ;------------------------------------------------------
        mov   @fb.prevcursor,tmp1   ; Get previous cursor position
        bl    @get_cursorcolor      ; Get cursor FG/BG color
                                    ; \ i  tmp1 = previous cursor position
                                    ; / o  outparm1 = cursor FG/BG color
        mov   @outparm1,tmp1        ; Get cursor color

        ;------------------------------------------------------
        ; Write to VDP TAT to hide cursor
        ;------------------------------------------------------
vdp.cursor.tat.fb.hide.dump:
        bl    @xvputb               ; VDP put single byte
                                    ; \ i  tmp0 = VDP write address
                                    ; / i  tmp1 = Byte to write 

        mov   *stack+,@wyx          ; Pop cursor position
        mov   @wyx,@fb.prevcursor   ; Update cursor position
        ;------------------------------------------------------
        ; Step 2: Check if cursor needs to be shown
        ;------------------------------------------------------
        inv   @fb.curtoggle          ; Flip cursor shape flag
        jeq   vdp.cursor.tat.fb.show ; Show FB cursor
        jmp   vdp.cursor.tat.fb.exit ; Exit
        ;------------------------------------------------------
        ; Step 3: Show cursor
        ;------------------------------------------------------
vdp.cursor.tat.fb.show:
        mov   @tv.ruler.visible,tmp0
        jeq   vdp.cursor.tat.fb.show.noruler
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler visible
        ;------------------------------------------------------
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0200            ; Topline + ruler adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        jmp   vdp.cursor.tat.fb.dump
        ;------------------------------------------------------
        ; Cursor position adjustment, ruler hidden
        ;------------------------------------------------------
vdp.cursor.tat.fb.show.noruler:
        mov   @wyx,tmp0             ; Get cursor YX
        ai    tmp0,>0100            ; Topline adjustment
        mov   tmp0,@wyx             ; Save cursor YX
        ;------------------------------------------------------
        ; Calculate VDP address
        ;------------------------------------------------------
vdp.cursor.tat.fb.dump:        
        bl    @yx2pnt               ; Calculate VDP address from @WYX
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP address
        ai    tmp0,vdp.tat.base     ; Add TAT base
        ;------------------------------------------------------
        ; Determine background color of cursor
        ;------------------------------------------------------
        mov   @wyx,tmp1             ; Get cursor position
        bl    @get_cursorcolor      ; Get cursor FG/BG color
                                    ; \ i  tmp1 = Cursor position
                                    ; / o  outparm1 = Cursor FG/BG color
        mov   @outparm1,tmp1        ; Get cursor color
        mov   @tv.curcolor,tmp1     ; Get cursor color        
        ;------------------------------------------------------
        ; Write to VDP TAT to show cursor
        ;------------------------------------------------------        
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
vdp.cursor.tat.fb.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller




***************************************************************
* get_cursorcolor
* Determine cursor foreground/background color
***************************************************************
* bl @get_cursorcolor
*--------------------------------------------------------------
* INPUT
* tmp1 = Cursor position
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Cursor foreground/background color
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
get_cursorcolor:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Check if within block markers M1-M2
        ;------------------------------------------------------
        srl   tmp1,8                ; MSB to LSB
        mov   tmp1,@parm1           ; Set row to check
        
        bl    @edb.block.match      ; Check if line within block markers M1-M2
                                    ; \ i  parm1 = row to check
                                    ; | o  outparm1 = >0000 if outside block
                                    ; /               >ffff if within block

        mov   @outparm1,tmp1        ; Get result
        jeq   !                     ; Outside block, use normal bg color
        ;------------------------------------------------------
        ; Use FG/BG color of block marking
        ;------------------------------------------------------
        bl    @pane.colorscheme.index 
                                    ; Get colorscheme address
                                    ; \ i  @pane.colorscheme.index = Colorscheme
                                    ; | o  @outparm1 = Word 0 ABCD
                                    ; | o  @outparm2 = Word 1 EFGH
                                    ; | o  @outparm3 = Word 2 IJKL
                                    ; | o  @outparm4 = Word 3 MNOP
                                    ; / o  @outparm5 = Word 4 QRST

        mov   @outparm3,tmp1        ; Get word 2 IJKL
        andi  tmp1,>00ff            ; Isolate KL (FG/BG color)
        mov   tmp1,@outparm1        ; Return color in outparm1
        jmp   get_cursorcolor.exit  ; Exit
        ;------------------------------------------------------
        ; Use FG/BG color of framebuffer
        ;------------------------------------------------------        
!       bl    @pane.colorscheme.index 
                                    ; Get colorscheme address
                                    ; \ i  @pane.colorscheme.index = Colorscheme
                                    ; | o  @outparm1 = Word 0 ABCD
                                    ; | o  @outparm2 = Word 1 EFGH
                                    ; | o  @outparm3 = Word 2 IJKL
                                    ; | o  @outparm4 = Word 3 MNOP
                                    ; / o  @outparm5 = Word 4 QRST

        mov   @outparm1,tmp1        ; Get word 0 ABCD
        srl   tmp1,8                ; Isolate AB (framebuffer FG/BG color)
        mov   tmp1,@outparm1        ; Return color in outparm1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
get_cursorcolor.exit:        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

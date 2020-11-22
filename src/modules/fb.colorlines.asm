* FILE......: fb.colorlines.asm
* Purpose...: Stevie Editor - Framebuffer refresh

***************************************************************
* fb.colorlines
* Colorize frame buffer content
***************************************************************
* bl @fb.colorlines
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
********|*****|*********************|**************************
fb.colorlines:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        ;------------------------------------------------------
        ; Check if anything to do
        ;------------------------------------------------------
        mov   @fb.colorize,tmp0     ; Check if colorization necessary
        jeq   fb.colorlines.exit    ; Exit if nothing to do. 

        mov   @edb.block.m1,tmp0    ; M1 unset?
        jeq   fb.colorlines.exit    ; Yes, skip marking color
        mov   @edb.block.m2,tmp0    ; M2 unset?
        jeq   fb.colorlines.exit    ; Yes, skip marking color
        ;------------------------------------------------------
        ; Color the lines in the framebuffer (TAT)
        ;------------------------------------------------------        
        li    tmp0,>1800            ; VDP start address        
        mov   @fb.scrrows.max,tmp3  ; Set loop counter
        mov   @fb.topline,tmp4      ; Position in editor buffer
        inc   tmp4                  ; M1/M2 use base 1 offset
        ;------------------------------------------------------
        ; 1. Set color for each line in framebuffer
        ;------------------------------------------------------        
fb.colorlines.loop:                
        mov   @edb.block.m1,tmp2
        c     tmp2,tmp4             ; M1 > current line
        jgt   fb.colorlines.normal  ; Yes, skip marking color

        mov   @edb.block.m2,tmp2
        c     tmp2,tmp4             ; M2 < current line
        jlt   fb.colorlines.normal  ; Yes, skip marking color
        ;------------------------------------------------------
        ; 1a. Set marking color
        ;------------------------------------------------------ 
        mov   @tv.markcolor,tmp1
        jmp   fb.colorlines.fill
        ;------------------------------------------------------
        ; 1b. Set normal text color
        ;------------------------------------------------------ 
fb.colorlines.normal:
        mov   @tv.color,tmp1
        srl   tmp1,8
        ;------------------------------------------------------
        ; 1c. Fill line with selected color 
        ;------------------------------------------------------ 
fb.colorlines.fill:
        li    tmp2,80               ; 80 characters to fill

        bl    @xfilv                ; Fill VDP VRAM
                                    ; \ i  tmp0 = VDP start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = count
        
        ai    tmp0,80               ; Next line
        inc   tmp4               
        dec   tmp3                  ; Update loop counter
        jgt   fb.colorlines.loop    ; Back to (1)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.colorlines.exit
        clr   @fb.colorize          ; Reset colorize flag
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11

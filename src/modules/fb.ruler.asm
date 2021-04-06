* FILE......: fb.ruler.asm
* Purpose...: Setup ruler with tab-positions

***************************************************************
* fb.ruler.init
* Setup ruler line
***************************************************************
* bl  @ruler.init
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
fb.ruler.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack            
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------        
        ; Initialize
        ;-------------------------------------------------------
        bl    @cpym2m
              data txt.ruler,fb.ruler,81
                                    ; Copy ruler from ROM to RAM    

        li    tmp0,tv.tabs.table    ; Get pointer to tabs table
        li    tmp2,>1100            ; Tab indicator
        ;------------------------------------------------------
        ; Setup ruler with current tab positions
        ;------------------------------------------------------
fb.ruler.init.loop:
        movb  *tmp0+,tmp1           ; \ Get tab position
        srl   tmp1,8                ; / Right align

        ci    tmp1,>00ff            ; End-of-list reached?
        jeq   fb.ruler.init.exit
        ;------------------------------------------------------
        ; Add tab-marker to ruler
        ;------------------------------------------------------
        ai    tmp1,fb.ruler         ; Add base address
        inc   tmp1                  ; Honour length-byte prefix
        movb  tmp2,*tmp1            ; Add tab-marker
        jmp   fb.ruler.init.loop    ; Next iteration
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.ruler.init.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return                                    

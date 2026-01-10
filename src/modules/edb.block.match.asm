* FILE......: edb.block.match.asm
* Purpose...: Check if current line is within block markers M1/M2

***************************************************************
* edb.block.match
* Check if current line is within block markers M1/M2
***************************************************************
*  bl   @edb.block.match
*--------------------------------------------------------------
* INPUT
* @parm1 = Row in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = >FFFF if within block, =0000 if outside block
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.block.match:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0  
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0
        jeq   edb.block.match.outside  ; Outside block if marker M1 unset
        mov   @edb.block.m2,tmp0
        jeq   edb.block.match.outside  ; Outside block if marker M2 unset
        mov   @cmdb.dialog,tmp0
        ci    tmp0,id.dialog.help      ; Help dialog active?
        jeq   edb.block.match.outside  ; Exit if help dialog active
        ;------------------------------------------------------
        ; Get editor line
        ;------------------------------------------------------
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inc   @outparm1             ; Base 1 for line number                                    
        ;------------------------------------------------------
        ; Check if within block markers M1/M2
        ;------------------------------------------------------
        c     @outparm1,@edb.block.m1  ; Current line < M1 ?       
        jlt   edb.block.match.outside  ; Outside block
        c     @outparm1,@edb.block.m2  ; Current line > M2 ?
        jgt   edb.block.match.outside  ; Outside block
        ;------------------------------------------------------
        ; Within block
        ;------------------------------------------------------
        seto  @outparm1             ; Within block. Set outparm1 to >FFFF
        jmp   edb.block.match.exit  ; Exit
        ;------------------------------------------------------
        ; Outside block
        ;------------------------------------------------------
edb.block.match.outside:
        clr   @outparm1             ; Outside block. Reset outparm1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.match.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11        
        b     *r11                  ; Return to caller        

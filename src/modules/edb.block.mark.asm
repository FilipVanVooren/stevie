* FILE......: edb.block.mark.asm
* Purpose...: Mark line for block operation

***************************************************************
* edb.block.mark.m1
* Mark M1 line for block operation
***************************************************************
*  bl   @edb.block.mark.m1
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.block.mark.m1:
        dect  stack
        mov   r11,*stack            ; Push return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inc   @outparm1             ; Add base 1

        mov   @outparm1,@edb.block.m1  
                                    ; Set block marker M1
        seto  @fb.colorize          ; Set colorize flag                
        seto  @fb.dirty             ; Trigger frame buffer refresh
        seto  @fb.status.dirty      ; Trigger status lines update
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.mark.m1.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* edb.block.mark.m2
* Mark M2 line for block operation
***************************************************************
*  bl   @edb.block.mark.m2
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.block.mark.m2:
        dect  stack
        mov   r11,*stack            ; Push return address
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        inc   @outparm1             ; Add base 1

        mov   @outparm1,@edb.block.m2
                                    ; Set block marker M2

        seto  @fb.colorize          ; Set colorize flag                
        seto  @fb.dirty             ; Trigger refresh
        seto  @fb.status.dirty      ; Trigger status lines update
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.mark.m2.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

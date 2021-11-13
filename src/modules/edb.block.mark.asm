* FILE......: edb.block.mark.asm
* Purpose...: Mark line for block operation

***************************************************************
* edb.block.mark.m1
* Mark M1 line for block operation
***************************************************************
*  bl   @edb.block.mark.m1
*--------------------------------------------------------------
* INPUT
* @edb.block.m1 = Marker M1 line
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* NONE
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
* @edb.block.m2 = Marker M2 line
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* NONE
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



***************************************************************
* edb.block.mark
* Mark either M1 or M2 line for block operation
***************************************************************
*  bl   @edb.block.mark
*--------------------------------------------------------------
* INPUT
* @edb.block.m1 = Marker M1 line
* @edb.block.m2 = Marker M2 line
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
edb.block.mark:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1        
        ;------------------------------------------------------
        ; Get current line position in editor buffer
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @outparm1,tmp1        ; Current line position in editor buffer
        inc   tmp1                  ; Add base 1
        ;------------------------------------------------------
        ; Check if M1 and M2 must be set
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp0    ; \ Is M1 unset?
        inc   tmp0                  ; /
        jne   edb.block.mark.is_line_m1
                                    ; No, skip to update M1
        ;------------------------------------------------------
        ; Set M1 and M2 and exit
        ;------------------------------------------------------
        bl    @edb.block.mark.m1    ; Set marker M1
        bl    @edb.block.mark.m2    ; Set marker M2
        jmp   edb.block.mark.exit
        ;------------------------------------------------------
        ; Set M1 and exit
        ;------------------------------------------------------
_edb.block.mark.m1.set:
        bl    @edb.block.mark.m1    ; Set marker M1
        jmp   edb.block.mark.exit
        ;------------------------------------------------------
        ; Update M1 if current line < M1
        ;------------------------------------------------------
edb.block.mark.is_line_m1:
        c     @edb.block.m1,tmp1    ; M1 > current line ?
        jgt   _edb.block.mark.m1.set
                                    ; Set M1 to current line and exit
        ;------------------------------------------------------
        ; Set M2 and exit
        ;------------------------------------------------------
        bl    @edb.block.mark.m2    ; Set marker M2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.block.mark.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop r11        
        b     *r11                  ; Return to caller        
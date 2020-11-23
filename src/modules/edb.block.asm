* FILE......: edb.line.mark.asm
* Purpose...: Stevie Editor - Mark line for block operation

***************************************************************
* edb.line.mark.m1
* Mark M1 line for block operation
***************************************************************
*  bl   @edb.line.mark.m1
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
edb.line.mark.m1:
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
        seto  @fb.dirty             ; Trigger refresh

        mov   @wyx,@fb.yxsave       ; Save cursor

        bl    @putat
              byte pane.botrow,52
              data txt.m1.set       ; Show M1 marker message

        mov   @fb.yxsave,@wyx       ; Restore cursor
        ;-------------------------------------------------------
        ; Setup one shot task for removing message
        ;-------------------------------------------------------  
        li    tmp0,pane.clearmsg.task.callback
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.line.mark.m1.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


***************************************************************
* edb.line.mark.m2
* Mark M2 line for block operation
***************************************************************
*  bl   @edb.line.mark.m2
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
edb.line.mark.m2:
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

        mov   @wyx,@fb.yxsave       ; Save cursor

        bl    @putat
              byte pane.botrow,52
              data txt.m2.set       ; Show M2 marker message

        mov   @fb.yxsave,@wyx       ; Restore cursor

        ;-------------------------------------------------------
        ; Setup one shot task for removing message
        ;-------------------------------------------------------  
        li    tmp0,pane.clearmsg.task.callback
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------        
edb.line.mark.m2.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

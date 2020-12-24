* FILE......: edb.block.copy.asm
* Purpose...: Copy code block

***************************************************************
* edb.block.copy
* Copy code block
***************************************************************
*  bl   @edb.block.copy
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
edb.block.copy:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Prepare for copy  *** COPY LOGIC IS WRONG FIX IT ****
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp1
        mov   @edb.block.m2,tmp2
        s     tmp1,tmp2
        ci    tmp2,0
        jgt   edb.block.copy.loop
        ;------------------------------------------------------
        ; Get current line position in editor buffer
        ;------------------------------------------------------
        mov   @fb.row,@parm1 
        bl    @fb.row2line          ; Row to editor line
                                    ; \ i @fb.topline = Top line in frame buffer 
                                    ; | i @parm1      = Row in frame buffer
                                    ; / o @outparm1   = Matching line in EB

        mov   @outparm1,tmp1        ; Current line position in editor buffer
        ;------------------------------------------------------
        ; Copy code block
        ;------------------------------------------------------
edb.block.copy.loop:        
        ;mov   @edb.block.m3,@parm1  ; Line for insert
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        
        bl    @idx.entry.insert     ; Reorganize index
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg

        

        inc   @edb.lines            ; One line added to editor buffer

        dec   tmp2
        jgt   edb.block.copy.loop   ; Next line
        

        seto  @edb.dirty
        seto  @fb.dirty

        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.copy.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
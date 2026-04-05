* FILE......: edb.line.getlength2.asm
* Purpose...: Get length of current row (as seen from editor buffer side)

***************************************************************
* edb.line.getlength2
* Get length of current row (as seen from editor buffer side)
***************************************************************
*  bl   @edb.line.getlength2
*--------------------------------------------------------------
* INPUT
* @fb.row = Row in frame buffer
*--------------------------------------------------------------
* OUTPUT
* @fb.row.length = Length of row
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edb.line.getlength2:
        .pushregs 0                 ; Push registers and return address on stack
        ;------------------------------------------------------
        ; Calculate line in editor buffer
        ;------------------------------------------------------
        mov   @fb.topline,tmp0      ; Get top line in frame buffer
        a     @fb.row,tmp0          ; Get current row in frame buffer        
        mov   tmp0,@parm1            
        ;------------------------------------------------------
        ; Get length
        ;------------------------------------------------------
        bl    @edb.line.getlength   ; Get length of specified line
                                    ; \ i  @parm1    = Line number (base 0)
                                    ; | o  @outparm1 = Length of line
                                    ; / o  @outparm2 = SAMS page

        mov   @outparm1,@fb.row.length
                                    ; Save row length
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.getlength2.exit:
        .popregs 0                  ; Pop registers and return to caller        

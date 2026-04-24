* FILE......: fb.row2line.asm
* Purpose...: Calculate line in editor buffer

***************************************************************
* fb.row2line
* Calculate line in editor buffer
***************************************************************
* bl @fb.row2line
*--------------------------------------------------------------
* INPUT
* @fb.topline = Top line in frame buffer
* @parm1      = Row in frame buffer (offset 0..@fb.scrrows)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Matching line in editor buffer
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Formula
* outparm1 = @fb.topline + @parm1
********|*****|*********************|**************************
fb.row2line:
        .pushregs 0                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Calculate line in editor buffer
        ;------------------------------------------------------
        mov   @parm1,tmp0
        a     @fb.topline,tmp0
        mov   tmp0,@outparm1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.row2line.exit:
        .popregs 0                  ; Pop registers and return to caller                

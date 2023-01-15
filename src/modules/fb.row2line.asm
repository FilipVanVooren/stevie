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
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
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
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

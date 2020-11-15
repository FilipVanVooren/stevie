* FILE......: edb.block.asm
* Purpose...: Stevie Editor - Block operations

***************************************************************
* edb.line.getlength
* Get length of specified line
***************************************************************
*  bl   @edb.line.getlength
*--------------------------------------------------------------
* INPUT
* @parm1 = Line number
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Length of line
* @outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.line.getlength:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        clr   @outparm1             ; Reset length
        clr   @outparm2             ; Reset SAMS bank
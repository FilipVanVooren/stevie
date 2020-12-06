* FILE......: colors.line.set
* Purpose...: Set color combination for line

***************************************************************
* colors.line.set
* Set color combination for line in VDP TAT
***************************************************************
* bl  @colors.line.set
*--------------------------------------------------------------
* INPUT
* @parm1 = Foreground / Background color
* @parm2 = Row on physical screen
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
colors.line.set:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   @parm1,*stack         ; Push parm1
        dect  stack
        mov   @parm2,*stack         ; Push parm2
        ;-------------------------------------------------------
        ; Dump colors for line in TAT
        ;-------------------------------------------------------
        mov   @parm2,tmp0           ; Get target line
        li    tmp1,colrow           ; Columns per row (spectra2)
        mpy   tmp0,tmp1             ; Calculate VDP address (results in tmp2!)

        mov   tmp2,tmp0             ; Set VDP start address
        ai    tmp0,vdp.tat.base     ; Add TAT base address
        mov   @parm1,tmp1           ; Get foreground/background color
        li    tmp2,80               ; Number of bytes to fill

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
colors.line.set.exit:
        mov   *stack+,@parm2        ; Pop @parm2
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller     
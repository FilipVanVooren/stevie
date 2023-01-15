* FILE......: fb.null2char.asm
* Purpose...: Replace all null characters with specified character

***************************************************************
* fb.null2char
* Replace all null characters with specified character
***************************************************************
*  bl   @fb.null2char
*--------------------------------------------------------------
* INPUT
* tmp1 = Replacement character
* tmp2 = Length of row
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
********|*****|*********************|**************************
fb.null2char:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        ;-------------------------------------------------------
        ; Sanity checks
        ;-------------------------------------------------------
        mov   tmp2,tmp2             ; Minimum 1 character
        jeq   fb.null2char.crash
        ci    tmp2,80               ; Maximum 80 characters
        jle   fb.null2char.init
        ;------------------------------------------------------
        ; Asserts failed
        ;------------------------------------------------------
fb.null2char.crash:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / Crash and halt system
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
fb.null2char.init:
        mov   tmp1,tmp3             ; Get character to write
        sla   tmp3,8                ; LSB to MSB
        clr   @fb.column

        bl    @fb.calc_pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

        mov   @fb.current,tmp0      ; Get position
        ;-------------------------------------------------------
        ; Loop over characters in line
        ;-------------------------------------------------------
fb.null2char.loop:
        clr   tmp1
        movb  *tmp0,tmp1            ; Get character
        jne   !                     ; Not a null character, skip it
        li    tmp1,>2a00            ; ASCII 32 in MSB
        movb  tmp3,*tmp0            ; Replace null character
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       inc   tmp0                  ; Move to next character
        dec   tmp2
        jgt   fb.null2char.loop     ; Repeat until done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.null2char.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

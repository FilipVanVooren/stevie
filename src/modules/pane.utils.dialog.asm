* FILE......: pane.utils.dialog.asm
* Purpose...: Dialog helper functions


***************************************************************
* dialog.hearts.tat
* Dump color for hearts in dialog
***************************************************************
* bl   @dialog.hearts.tat
*--------------------------------------------------------------
* INPUT
* @parm1 = Start column (position 1st heart)
*
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* none
********|*****|*********************|**************************
dialog.hearts.tat:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Get background color for hearts in TAT
        ;-------------------------------------------------------
        mov   @cmdb.vdptop,tmp0     ; \ 2nd row in CMDB TAT
        ai    tmp0,80               ; /
        a     @parm1,tmp0           ; Add start column (position 1st heart)

        bl    @xvgetb               ; Read VDP byte

        mov   tmp0,tmp1             ; Save color combination
        andi  tmp1,>000f            ; Only keep background
        ori   tmp1,>0060            ; Set foreground color to red

        mov   @cmdb.vdptop,tmp0     ; \ 2nd row in CMDB TAT
        ai    tmp0,80               ; /
        a     @parm1,tmp0           ; Add start column (position 1st heart)        

        li    tmp2,10               ; Set loop counter
        ;-------------------------------------------------------
        ; Dump colors for 10 hearts in TI Basic dialog (TAT)
        ;-------------------------------------------------------
dialog.hearts.tat.loop:
        ;-------------------------------------------------------
        ; Dump color for single heart
        ;-------------------------------------------------------
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        li    tmp2,2                ; 2 bytes 

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;-------------------------------------------------------
        ; Next iteration
        ;-------------------------------------------------------
        ai    tmp0,4                ; Next heart in TAT     
        dec   tmp2                  ; Next iteration

        jne   dialog.hearts.tat.loop
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.hearts.tat.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

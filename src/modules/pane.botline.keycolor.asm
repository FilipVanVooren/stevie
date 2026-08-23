* FILE......: pane.botline.keycolor.asm
* Purpose...: Colorize key markers on bottom line using cmdb.keycolors array

***************************************************************
* pane.botline.keycolor
* Colorize key markers in bottom line using pointer at @cmdb.keycolors
***************************************************************
* bl  @pane.botline.keycolor
*--------------------------------------------------------------
* INPUT
* @cmdb.keycolors = Pointer to byte array with marker positions
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0 = pointer to keycolors array
* tmp1 = Byte array byte
* tmp2 = Repeat count
* tmp3 = Color combination for key marker (ST)
* tmp4 = Copy of tmp1
********|*****|*********************|**************************
pane.botline.keycolor:
        .pushregs 4                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Get pointer to key color array
        ;------------------------------------------------------
        mov   @cmdb.keycolors,tmp0       ; tmp0 = pointer to byte array (X,count,...,>ff)
        jeq   pane.botline.keycolor.exit ; Exit early on null pointer
        ;------------------------------------------------------
        ; Ensure we have current color scheme data available
        ; This fills @outparm1..@outparm5 where outparm5 contains QRST
        ;------------------------------------------------------
        bl    @pane.colorscheme.index ; \ Compose final TAT byte from QRST: 
                                      ; / FG=S (high nibble of low byte), BG=T (low nibble)
        mov   @outparm5,tmp3          ; \ tmp3 = QRST
        andi  tmp3,>00ff              ; / Only keep ST
        ;------------------------------------------------------
        ; Loop through array of (X,repeat) pairs
        ; Each entry: X pos (byte), repeat count (byte). Terminator: >ff
        ;------------------------------------------------------
pane.botline.keycolor.loop:
        movb  *tmp0+,tmp1           ; Read X position (byte)
        srl   tmp1,8                ; Move to LSB
        ci    tmp1,>ff              ; Check sentinel
        jeq   pane.botline.keycolor.exit
        mov   tmp1,tmp4             ; Backup tmp1
        movb  *tmp0+,tmp2           ; Read repeat count (byte)
        srl   tmp2,8                ; Move to LSB (repeat count)
        ;------------------------------------------------------
        ; Dump color to TAT
        ;------------------------------------------------------
pane.botline.keycolor.dump.tat:        
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2

        li    tmp0,vdp.botrow.tat   ; \ Get TAT address of bottom row
        a     tmp4,tmp0             ; / Add X position

        mov   tmp3,tmp1             ; Get color combination
        mov   *stack,tmp2           ; Get repeat count 

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill

        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0

        jmp   pane.botline.keycolor.loop
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.botline.keycolor.exit:
        .popregs 4                 ; Pop registers and return to caller

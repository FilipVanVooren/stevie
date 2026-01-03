* FILE......: pane.colorscheme.index.asm
* Purpose...: Get color scheme by index

***************************************************************
* pane.colorscheme.index
* Get color scheme by index
***************************************************************
* bl  @pane.colorscheme.index
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into current color scheme table
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Address of color scheme data
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
pane.colorscheme.index:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Calculate index into colorscheme table
        ;-------------------------------------------------------
        mov   @tv.colorscheme,tmp0  ; Get color scheme index
        dec   tmp0                  ; Internally work with base 0
        mov   tmp0,tmp1             ; \
        sla   tmp0,3                ; | index = index * 10
        sla   tmp1,1                ; | 
        a     tmp1,tmp0             ; /
        ai    tmp0,tv.colorscheme.table 
                                    ; Add base for color scheme data table
        ;-------------------------------------------------------
        ; Get color scheme data
        ;-------------------------------------------------------                                    
        mov   *tmp0+,@outparm1      ; Get ABCD
        mov   *tmp0+,@outparm2      ; Get EFGH
        mov   *tmp0+,@outparm3      ; Get IJKL
        mov   *tmp0+,@outparm4      ; Get MNOP
        mov   *tmp0+,@outparm5      ; Get QRST
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.colorscheme.index.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



***************************************************************
* pane.colorscheme.address
* Get color scheme address by index
***************************************************************
* bl  @pane.colorscheme.address
*--------------------------------------------------------------
* INPUT
* @tv.colorscheme = Index into current color scheme table
*--------------------------------------------------------------
* OUTPUT
* outparm1 = Pointer to color scheme data
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
pane.colorscheme.address:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Calculate index into colorscheme table
        ;-------------------------------------------------------
        mov   @tv.colorscheme,tmp0  ; Get color scheme index
        dec   tmp0                  ; Internally work with base 0
        mov   tmp0,tmp1             ; \
        sla   tmp0,3                ; | index = index * 10
        sla   tmp1,1                ; | 
        a     tmp1,tmp0             ; /
        ai    tmp0,tv.colorscheme.table 
                                    ; Add base for color scheme data table
        mov   tmp0,@outparm1        ; Store address of color scheme data
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
pane.colorscheme.address.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

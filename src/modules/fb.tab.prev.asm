* FILE......: fb.tab.prev.asm
* Purpose...: Tabbing functionality in frame buffer


***************************************************************
* fb.tab.prev
* Move cursor to previous tab position
***************************************************************
*  bl   @fb.tab.prev
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* For simplicity reasons we're assuming base 1 during copy
* (first line starts at 1 instead of 0).
* Makes it easier when comparing values.
********|*****|*********************|**************************
fb.tab.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
        li    tmp0,tv.tabs.table.rl ; Get pointer to tabs table
        ;-------------------------------------------------------
        ; Find previous tab position
        ;-------------------------------------------------------
fb.tab.prev.loop:
        movb  *tmp0+,tmp1           ; \ Get tab position
        srl   tmp1,8                ; / Right align

        ci    tmp1,>00ff            ; End-of-list reached?
        jeq   fb.tab.prev.eol       ; Yes, home cursor and exit
        ;-------------------------------------------------------
        ; Compare position
        ;-------------------------------------------------------
        c     @fb.column,tmp1       ; Cursor < tab position?
        jle   !                     ; Yes, next loop iteration
        ;-------------------------------------------------------
        ; Set cursor
        ;-------------------------------------------------------
        mov   tmp1,@fb.column       ; Set cursor on tab position

        dect  stack
        mov   tmp0,*stack           ; Push tmp0

        mov   tmp1,tmp0             ; \ Set VDP cursor column position
        bl    @xsetx                ; / i  tmp0 = new X value

        mov   *stack+,tmp0          ; Pop tmp0

        bl    @fb.calc_pointer      ; Calculate position in frame buffer

        seto  @fb.row.dirty         ; Current row dirty in frame buffer
        seto  @fb.dirty             ; Frame buffer dirty
        seto  @fb.status.dirty      ; Refresh status line
        seto  @edb.dirty            ; Editor buffer dirty (text changed)
        jmp   fb.tab.prev.exit
        ;-------------------------------------------------------
        ; End-of-list reached, special treatment home cursor
        ;-------------------------------------------------------
fb.tab.prev.eol:
        clr   @fb.column            ; Home cursor
        clr   tmp0                  ; Home cursor

        bl    @xsetx                ; \ Set VDP cursor column position
                                    ; / i  tmp0 = new X value

        seto  @fb.status.dirty      ; Refresh status line

        jmp   fb.tab.prev.exit      ; Exit
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       dec   tmp2
        jgt   fb.tab.prev.loop
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.tab.prev.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

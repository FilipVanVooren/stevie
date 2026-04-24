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
        .pushregs 2                 ; Push return address and registers on stack
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

        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer

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
        .popregs 2                  ; Pop registers and return to caller                

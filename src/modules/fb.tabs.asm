* FILE......: fb.tabs.asm
* Purpose...: Tabbing functionality in frame buffer



***************************************************************
* _fb.null2space
* Replace all null characters with white space
***************************************************************
*  bl   @_fb.null2space
*--------------------------------------------------------------
* INPUT
* tmp2 = Length of row
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* Internal method. Only to be called from fb.tab.asm
********|*****|*********************|**************************
_fb.null2space:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Sanity checks
        ;-------------------------------------------------------
        mov   tmp2,tmp2             ; Minimum 1 character
        jeq   _fb.null2space.crash  
        ci    tmp2,80               ; Maximum 80 characters
        jle   _fb.null2space.init
        ;------------------------------------------------------
        ; Asserts failed
        ;------------------------------------------------------
_fb.null2space.crash:        
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system       
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
_fb.null2space.init:
        clr   @fb.column
        bl    @fb.calc_pointer      ; Beginning of row
        mov   @fb.current,tmp0      ; Get position
        ;-------------------------------------------------------
        ; Loop over characters in line
        ;-------------------------------------------------------
_fb.null2space.loop:
        clr   tmp1
        movb  *tmp0,tmp1            ; Get character
        jne   !                     ; Not a null character, skip it
        li    tmp1,>2a00            ; ASCII 32 in MSB
        movb  tmp1,*tmp0            ; Replace null character
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       inc   tmp0                  ; Move to next character
        dec   tmp2
        jgt   _fb.null2space.loop   ; Repeat until done
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_fb.null2space.exit:
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0          
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



***************************************************************
* fb.tab.next
* Move cursor to next tab position
***************************************************************
*  bl   @fb.tab.next
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
fb.tab.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Initialize
        ;-------------------------------------------------------
        li    tmp0,tv.tabs.table    ; Get pointer to tabs table
        li    tmp2,20               ; Up to 20 tabs supported
        ;-------------------------------------------------------
        ; Find next tab position
        ;-------------------------------------------------------
fb.tab.next.loop:        
        movb  *tmp0+,tmp1           ; \ Get tab position
        srl   tmp1,8                ; / Right align
        ;-------------------------------------------------------
        ; Compare position
        ;-------------------------------------------------------
        c     @fb.column,tmp1       ; Cursor > tab position?
        jhe   !                     ; Yes, next loop iteration
        ;-------------------------------------------------------
        ; Set cursor
        ;-------------------------------------------------------
        mov   tmp1,tmp2             ; \ 
        bl    @_fb.null2space       ; | Replace any null characters with space
                                    ; / i  tmp2 = Length of row

        mov   tmp1,@fb.column       ; Set cursor on tab position

        mov   tmp1,tmp0             ; \ Set VDP cursor column position
        bl    @xsetx                ; / i  tmp0 = new X value

        bl    @fb.calc_pointer      ; Calculate position in frame buffer

        seto  @fb.row.dirty         ; Current row dirty in frame buffer
        seto  @fb.status.dirty      ; Refresh status line        
        seto  @edb.dirty            ; Editor buffer dirty (text changed)
        jmp   fb.tab.next.exit      ; Exit
        ;-------------------------------------------------------
        ; Prepare for next iteration
        ;-------------------------------------------------------
!       dec   tmp2
        jne   fb.tab.next.loop
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.tab.next.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11 
        b     *r11                  ; Return to caller
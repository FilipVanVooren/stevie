* FILE......: fb.tabs.asm
* Purpose...: Tabbing functionality in frame buffer

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
        li   tmp0,tv.tabs.table     ; Get pointer to tabs table
        li   tmp2,20                ; Up to 20 tabs supported
        ;-------------------------------------------------------
        ; Find next tab position
        ;-------------------------------------------------------
fb.tab.next.loop:        
        movb *tmp0+,tmp1            ; \ Get tab position
        srl  tmp1,8                 ; / Right align
        ;-------------------------------------------------------
        ; Compare position
        ;-------------------------------------------------------
        c    @fb.column,tmp1        ; Cursor > tab position?
        jgt  !                      ; Yes, next loop iteration

        mov  tmp1,@fb.column        ; Set cursor on tab position
        jmp  fb.tab.next.exit       ; Exit

!       dec  tmp2
        jne  fb.tab.next.loop
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.tab.next.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11 
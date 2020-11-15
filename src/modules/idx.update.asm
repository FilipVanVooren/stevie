* FILE......: idx.update.asm
* Purpose...: Stevie Editor - Update index entry

***************************************************************
* idx.entry.update
* Update index entry - Each entry corresponds to a line
***************************************************************
* bl @idx.entry.update
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer
* @parm2    = Pointer to line in editor buffer
* @parm3    = SAMS page
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Pointer to updated index entry
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
idx.entry.update:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Get parameters
        ;------------------------------------------------------    
        mov   @parm1,tmp0           ; Get line number
        mov   @parm2,tmp1           ; Get pointer
        jeq   idx.entry.update.clear
                                    ; Special handling for "null"-pointer
        ;------------------------------------------------------
        ; Calculate LSB value index slot (pointer offset)
        ;------------------------------------------------------      
        andi  tmp1,>0fff            ; Remove high-nibble from pointer
        srl   tmp1,4                ; Get offset (divide by 16)
        ;------------------------------------------------------
        ; Calculate MSB value index slot (SAMS page editor buffer)
        ;------------------------------------------------------      
        swpb  @parm3
        movb  @parm3,tmp1           ; Put SAMS page in MSB
        swpb  @parm3                ; \ Restore original order again, 
                                    ; / important for messing up caller parm3!
        ;------------------------------------------------------
        ; Update index slot
        ;------------------------------------------------------      
idx.entry.update.save:
        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page

        mov   @outparm1,tmp0        ; \ Update index slot
        mov   tmp1,@idx.top(tmp0)   ; / 
        mov   tmp0,@outparm1        ; Pointer to updated index entry        
        jmp   idx.entry.update.exit
        ;------------------------------------------------------
        ; Special handling for "null"-pointer
        ;------------------------------------------------------      
idx.entry.update.clear:
        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page

        mov   @outparm1,tmp0        ; \ Clear index slot
        clr   @idx.top(tmp0)        ; / 
        mov   tmp0,@outparm1        ; Pointer to updated index entry        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.update.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

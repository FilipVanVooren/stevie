* FILE......: idx.pointer.asm
* Purpose...: Stevie Editor - Get pointer to line in editor buffer

*//////////////////////////////////////////////////////////////
*                  Stevie Editor - Index Management
*//////////////////////////////////////////////////////////////



***************************************************************
* idx.pointer.get
* Get pointer to editor buffer line content
***************************************************************
* bl @idx.pointer.get
*--------------------------------------------------------------
* INPUT
* @parm1 = Line number in editor buffer
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Pointer to editor buffer line content
* @outparm2 = SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
idx.pointer.get:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Get slot entry
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer        

        bl    @_idx.samspage.get    ; Get SAMS page with index slot
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page

        mov   @outparm1,tmp0        ; \ Get slot entry
        mov   @idx.top(tmp0),tmp1   ; / 

        jeq   idx.pointer.get.parm.null
                                    ; Skip if index slot empty
        ;------------------------------------------------------
        ; Calculate MSB (SAMS page)
        ;------------------------------------------------------      
        mov   tmp1,tmp2             ; \
        srl   tmp2,8                ; / Right align SAMS page
        ;------------------------------------------------------
        ; Calculate LSB (pointer address)
        ;------------------------------------------------------      
        andi  tmp1,>00ff            ; Get rid of MSB (SAMS page)
        sla   tmp1,4                ; Multiply with 16
        ai    tmp1,edb.top          ; Add editor buffer base address
        ;------------------------------------------------------
        ; Return parameters
        ;------------------------------------------------------
idx.pointer.get.parm:
        mov   tmp1,@outparm1        ; Index slot -> Pointer        
        mov   tmp2,@outparm2        ; Index slot -> SAMS page
        jmp   idx.pointer.get.exit
        ;------------------------------------------------------
        ; Special handling for "null"-pointer
        ;------------------------------------------------------
idx.pointer.get.parm.null:
        clr   @outparm1
        clr   @outparm2
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.pointer.get.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
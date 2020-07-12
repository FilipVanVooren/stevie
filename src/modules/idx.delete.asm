* FILE......: idx_delete.asm
* Purpose...: Stevie Editor - Delete index slot

*//////////////////////////////////////////////////////////////
*              Stevie Editor - Index Management
*//////////////////////////////////////////////////////////////





***************************************************************
* _idx.entry.delete.reorg
* Reorganize index slot entries
***************************************************************
* bl @_idx.entry.delete.reorg
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete
********|*****|*********************|**************************
_idx.entry.delete.reorg:
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
        ai    tmp0,idx.top          ; Add index base to offset        
        mov   tmp0,tmp1             ; a = current slot
        inct  tmp1                  ; b = current slot + 2
        ;------------------------------------------------------
        ; Loop forward until end of index
        ;------------------------------------------------------
_idx.entry.delete.reorg.loop:        
        mov   *tmp1+,*tmp0+         ; Copy b -> a       
        dec   tmp2                  ; tmp2--
        jne   _idx.entry.delete.reorg.loop
                                    ; Loop unless completed
        b     *r11                  ; Return to caller



***************************************************************
* idx.entry.delete
* Delete index entry - Close gap created by delete
***************************************************************
* bl @idx.entry.delete
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer to delete
* @parm2    = Line number of last line to check for reorg
*--------------------------------------------------------------
* Register usage
* tmp0,tmp2
********|*****|*********************|**************************
idx.entry.delete:
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
        ;------------------------------------------------------
        ; Get index slot
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer

        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page
        
        mov   @outparm1,tmp0        ; Index offset
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop         
        jeq   idx.entry.delete.lastline
                                    ; Special treatment if last line
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @parm2,tmp3
        ci    tmp3,2048
        jle   idx.entry.delete.reorg.simple
                                    ; Do simple reorg only if single
                                    ; SAMS index page, otherwise complex reorg.
        ;------------------------------------------------------
        ; Complex index reorganization (multiple SAMS pages)
        ;------------------------------------------------------
idx.entry.delete.reorg.complex:        
        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continious memory region                

        bl    @_idx.entry.delete.reorg
                                    ; Reorganize index


        bl    @_idx.sams.mapcolumn.off 
                                    ; Restore memory window layout

        jmp   idx.entry.delete.lastline
        ;------------------------------------------------------
        ; Simple index reorganization
        ;------------------------------------------------------
idx.entry.delete.reorg.simple:
        bl    @_idx.entry.delete.reorg
        ;------------------------------------------------------
        ; Last line 
        ;------------------------------------------------------      
idx.entry.delete.lastline:
        clr   *tmp0
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

* FILE......: idx_delete.asm
* Purpose...: TiVi Editor - Delete index slot

*//////////////////////////////////////////////////////////////
*              TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////


***************************************************************
* _idx.sams.mapcolumn.on
* Flatten SAMS index pages into continious memory region.
* Gives 20 KB of index space (2048 * 5 = 10240 lines per file) 
*
* >b000  1st index page
* >c000  2nd index page
* >d000  3rd index page
* >e000  4th index page
* >f000  5th index page
***************************************************************
* bl @_idx.sams.mapcolumn.on
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside idx module
*--------------------------------------------------------------
_idx.sams.mapcolumn.on:
        dect  stack
        mov   r11,*stack            ; Push return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
*--------------------------------------------------------------
* Map index pages into memory window  (b000-?????)
*--------------------------------------------------------------
        mov   @idx.sams.lopage,tmp0
        li    tmp1,idx.top

        mov   @idx.sams.hipage,tmp2
        s     @idx.sams.lopage,tmp2 ; Set loop counter
        ;-------------------------------------------------------
        ; Sanity check
        ;-------------------------------------------------------      
        ci    tmp2,5                ; Crash if too many index pages
        jlt   !
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
        ;-------------------------------------------------------
        ; Loop over banks
        ;------------------------------------------------------- 
!       bl    @xsams.page.set       ; Set SAMS page
                                    ; \ i  tmp0  = SAMS page number
                                    ; / i  tmp1  = Memory address

        inc   tmp0                  ; Next SAMS index page
        ai    tmp1,>1000            ; Next memory region
        dec   tmp2                  ; Update loop counter
        jgt   -!                    ; Next SAMS page
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
_idx.sams.mapcolumn.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop return address
        b     *r11                  ; Return to caller       



***************************************************************
* _idx.entry.delete.reorg.single
* Reorganize index slot entries (single SAMS page)
***************************************************************
* bl @_idx.entry.delete.reorg.single
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete
*--------------------------------------------------------------
_idx.entry.delete.reorg.single:
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
!       mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
        inct  tmp0                  ; Next index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed
        b     *r11                  ; Return to caller



***************************************************************
* idx.entry.delete._reorg.multiple
* Reorganize index slot entries (accross multiple banks)
***************************************************************
* bl @_idx.entry.delete.reorg.multiple
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete.
*--------------------------------------------------------------
_idx.entry.delete.reorg.multiple:
        ;------------------------------------------------------
        ; Page-in ALL index pages for continious memory region
        ;------------------------------------------------------
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
*--------------------------------------------------------------
idx.entry.delete:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Get index slot
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer

        bl    @idx._samspage.get    ; Get SAMS page for index
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
        c     @idx.sams.page,@idx.sams.hipage
        jeq   idx.entry.delete.reorg.single
                                    ; If only one SAMS index page or at last
                                    ; SAMS index page then do simple reorg        
        ;------------------------------------------------------
        ; Complex index reorganization (multiple SAMS pages)
        ;------------------------------------------------------
idx.entry.delete.reorg.complex:        
                



;       bl    @idx.entry.delete._reorg.complex                                          
        jmp   idx.entry.delete.lastline
        ;------------------------------------------------------
        ; Simple index reorganization
        ;------------------------------------------------------
idx.entry.delete.reorg.simple:
        bl    @_idx.entry.delete.reorg.simple                                          
        ;------------------------------------------------------
        ; Last line 
        ;------------------------------------------------------      
idx.entry.delete.lastline:
        clr   @idx.top(tmp0)
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

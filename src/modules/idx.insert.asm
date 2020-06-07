* FILE......: idx.insert.asm
* Purpose...: Stevie Editor - Insert index slot

*//////////////////////////////////////////////////////////////
*                  Stevie Editor - Index Management
*//////////////////////////////////////////////////////////////





***************************************************************
* _idx.entry.insert.reorg
* Reorganize index slot entries
***************************************************************
* bl @_idx.entry.insert.reorg
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_delete
*--------------------------------------------------------------
_idx.entry.insert.reorg:
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
        inct  tmp2                  ; Adjust one time

!       mov   @idx.top(tmp0),@idx.top+2(tmp0)
                                    ; Move index entry

        dect  tmp0                  ; Previous index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed

        clr   @idx.top(tmp0)        ; Clear new index entry
        b     *r11                  ; Return to caller





***************************************************************
* idx.entry.insert
* Insert index entry
***************************************************************
* bl @idx.entry.insert
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer to insert
* @parm2    = Line number of last line to check for reorg
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp2
*--------------------------------------------------------------
idx.entry.insert:
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

        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page

        mov   @outparm1,tmp0        ; Index offset
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop         
        jeq   idx.entry.insert.reorg.simple
                                    ; Special treatment if last line
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.insert.reorg:
        c     @idx.sams.page,@idx.sams.hipage
        jeq   idx.entry.insert.reorg.simple
                                    ; If only one SAMS index page or at last
                                    ; SAMS index page, then do simple reorg.        
        ;------------------------------------------------------
        ; Complex index reorganization (multiple SAMS pages)
        ;------------------------------------------------------
idx.entry.insert.reorg.complex:        
        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continious memory region                

        bl    @_idx.entry.insert.reorg
                                    ; Reorganize index

        bl    @_idx.sams.mapcolumn.off 
                                    ; Restore memory window layout

        jmp   idx.entry.insert.exit
        ;------------------------------------------------------
        ; Simple index reorganization
        ;------------------------------------------------------
idx.entry.insert.reorg.simple:
        bl    @_idx.entry.insert.reorg
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.insert.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
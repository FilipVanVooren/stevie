* FILE......: idx.insert.asm
* Purpose...: Insert index entry

***************************************************************
* _idx.entry.insert.reorg
* Reorganize index slot entries
***************************************************************
* bl @_idx.entry.insert.reorg
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from idx_entry_insert
********|*****|*********************|**************************
_idx.entry.insert.reorg:
        ;------------------------------------------------------
        ; Assert 1
        ;------------------------------------------------------ 
        ci    tmp2,2048*5           ; Crash if loop counter value is unrealistic
                                    ; (max 5 SAMS pages with 2048 index entries)

        jle   !                     ; Continue if ok
        ;------------------------------------------------------
        ; Crash and burn
        ;------------------------------------------------------        
_idx.entry.insert.reorg.crash:        
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system     
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------        
!       ai    tmp0,idx.top          ; Add index base to offset
        mov   tmp0,tmp1             ; a = current slot
        inct  tmp1                  ; b = current slot + 2
        inc   tmp2                  ; One time adjustment for current line
        ;------------------------------------------------------
        ; Assert 2
        ;------------------------------------------------------
        mov   tmp2,tmp3             ; Number of slots to reorganize
        sla   tmp3,1                ; adjust to slot size
        neg   tmp3                  ; tmp3 = -tmp3
        a     tmp0,tmp3             ; tmp3 = tmp3 + tmp0
        ci    tmp3,idx.top - 2      ; Address before top of index ?
        jlt   _idx.entry.insert.reorg.crash
                                    ; If yes, crash
        ;------------------------------------------------------
        ; Loop backwards from end of index up to insert point
        ;------------------------------------------------------        
_idx.entry.insert.reorg.loop:
        mov   *tmp0,*tmp1           ; Copy a -> b
        dect  tmp0                  ; Move pointer up
        dect  tmp1                  ; Move pointer up
        dec   tmp2                  ; Next index entry
        jgt   _idx.entry.insert.reorg.loop
                                    ; Repeat until done
        ;------------------------------------------------------
        ; Clear index entry at insert point
        ;------------------------------------------------------         
        inct  tmp0                  ; \ Clear index entry for line
        clr   *tmp0                 ; / following insert point

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
********|*****|*********************|**************************
idx.entry.insert:
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
        mov   @parm2,tmp3
        ci    tmp3,2048
        jle   idx.entry.insert.reorg.simple
                                    ; Do simple reorg only if single
                                    ; SAMS index page, otherwise complex reorg.
        ;------------------------------------------------------
        ; Complex index reorganization (multiple SAMS pages)
        ;------------------------------------------------------
idx.entry.insert.reorg.complex:        
        bl    @_idx.sams.mapcolumn.on
                                    ; Index in continious memory region    
                                    ; b000 - ffff (5 SAMS pages)            

        mov   @parm2,tmp0           ; Last line number in editor buffer
        sla   tmp0,1                ; tmp0 * 2

        bl    @_idx.entry.insert.reorg
                                    ; Reorganize index
                                    ; \ i  tmp0 = Last line in index
                                    ; / i  tmp2 = Num. of index entries to move

        bl    @_idx.sams.mapcolumn.off 
                                    ; Restore memory window layout

        jmp   idx.entry.insert.exit
        ;------------------------------------------------------
        ; Simple index reorganization
        ;------------------------------------------------------
idx.entry.insert.reorg.simple:
        mov   @parm2,tmp0           ; Last line number in editor buffer

        bl    @_idx.samspage.get    ; Get SAMS page for index
                                    ; \ i  tmp0     = Line number
                                    ; / o  outparm1 = Slot offset in SAMS page

        mov   @outparm1,tmp0        ; Index offset

        bl    @_idx.entry.insert.reorg
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.insert.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller
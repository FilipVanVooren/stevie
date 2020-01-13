* FILE......: index.asm
* Purpose...: TiVi Editor - Index module

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////

***************************************************************
* Size of index page is 4K and allows indexing of 2048 lines.
* Each index slot (1 word) contains the pointer to the line in
* the editor buffer.
* 
* The editor buffer always resides at (a000 -> ffff) for a total
* of 24K. Therefor when dereferencing, the base >a000 is to be 
* added and only the offset (0000 -> 5fff) is stored in the index
* itself.
* 
* The pointers' MSB high-nibble determines the SAMS bank to use:
*
*   0 > SAMS bank 0
*   1 > SAMS bank 0
*   2 > SAMS bank 0
*   3 > SAMS bank 0
*   4 > SAMS bank 0
*   5 > SAMS bank 0
*   6 > SAMS bank 1
*   7 > SAMS bank 2
*   8 > SAMS bank 3
*   9 > SAMS bank 4
*   a > SAMS bank 5
*   b > SAMS bank 6
*   c > SAMS bank 7
*   d > SAMS bank 8
*   e > SAMS bank 9
*   f > SAMS bank A
*
* First line in editor buffer starts at offset 2 (a002), this
* allows index to contain "null" pointers which mean empty line
* without reference to editor buffer.
***************************************************************


***************************************************************
* idx.init
* Initialize index
***************************************************************
* bl @idx.init
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
***************************************************************
idx.init:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,idx.top
        mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure
        ;------------------------------------------------------
        ; Create index slot 0
        ;------------------------------------------------------
        bl    @film
        data  idx.top,>00,idx.size  ; Clear index
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.init.exit:        
        b     @poprt                ; Return to caller



***************************************************************
* idx.entry.update
* Update index entry - Each entry corresponds to a line
***************************************************************
* bl @idx.entry.update
*--------------------------------------------------------------
* INPUT
* @parm1    = Line number in editor buffer
* @parm2    = Pointer to line in editor buffer 
* @parm3    = SAMS bank (0-A)
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Pointer to updated index entry
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
idx.entry.update:
        mov   @parm1,tmp0           ; Line number in editor buffer
        ;------------------------------------------------------
        ; Calculate offset
        ;------------------------------------------------------      
        mov   @parm2,tmp1
        ai    tmp1,-edb.top         ; Substract editor buffer base,
                                    ; we only store the offset

        ;------------------------------------------------------
        ; Inject SAMS bank into high-nibble MSB of pointer
        ;------------------------------------------------------      
        mov   @parm3,tmp2
        jeq   idx.entry.update.save ; Skip for SAMS bank 0

        ; <still to do>

        ;------------------------------------------------------
        ; Update index slot
        ;------------------------------------------------------      
idx.entry.update.save:        
        sla   tmp0,1                ; line number * 2
        mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.update.exit:
        mov   tmp0,@outparm1        ; Pointer to updated index entry
        b     *r11                  ; Return


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
* OUTPUT
* @outparm1 = Pointer to deleted line (for undo)
*--------------------------------------------------------------
* Register usage
* tmp0,tmp2
*--------------------------------------------------------------
idx.entry.delete:
        mov   @parm1,tmp0           ; Line number in editor buffer
        ;------------------------------------------------------
        ; Calculate address of index entry and save pointer
        ;------------------------------------------------------      
        sla   tmp0,1                ; line number * 2
        mov   @idx.top(tmp0),@outparm1 
                                    ; Pointer to deleted line
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop 
        jne   idx.entry.delete.reorg
        ;------------------------------------------------------
        ; Special treatment if last line
        ;------------------------------------------------------
        clr   @idx.top(tmp0)
        jmp   idx.entry.delete.exit
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
        inct  tmp0                  ; Next index entry
        dec   tmp2                  ; tmp2--
        jne   idx.entry.delete.reorg
                                    ; Loop unless completed
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.exit:
        b     *r11                  ; Return


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
        mov   @parm2,tmp0           ; Last line number in editor buffer
        ;------------------------------------------------------
        ; Calculate address of index entry and save pointer
        ;------------------------------------------------------      
        sla   tmp0,1                ; line number * 2
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop 
        jne   idx.entry.insert.reorg
        ;------------------------------------------------------
        ; Special treatment if last line
        ;------------------------------------------------------
        mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
        clr   @idx.top+0(tmp0)      ; Clear new index entry
        jmp   idx.entry.insert.$$
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.insert.reorg:
        inct  tmp2                  ; Adjust one time
!       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
        dect  tmp0                  ; Previous index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed

        clr   @idx.top+4(tmp0)      ; Clear new index entry
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.insert.$$:
        b     *r11                  ; Return



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
* @outparm2 = SAMS bank (>0 - >a)
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
idx.pointer.get:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Get pointer
        ;------------------------------------------------------
        mov   @parm1,tmp0           ; Line number in editor buffer
        ;------------------------------------------------------
        ; Calculate index entry 
        ;------------------------------------------------------      
        sla   tmp0,1                ; line number * 2
        mov   @idx.top(tmp0),tmp1   ; Get offset
        ;------------------------------------------------------
        ; Get SAMS bank
        ;------------------------------------------------------      
        mov   tmp1,tmp2
        srl   tmp2,12               ; Remove offset part

        ci    tmp2,5                ; SAMS bank 0                
        jle   idx.pointer.get.samsbank0

        ai    tmp2,-5               ; Get SAMS bank
        mov   tmp2,@outparm2        ; Return SAMS bank
        jmp   idx.pointer.get.addbase
        ;------------------------------------------------------
        ; SAMS Bank 0 (or only 32K memory expansion)
        ;------------------------------------------------------
idx.pointer.get.samsbank0:
        clr   @outparm2             ; SAMS bank 0        
        ;------------------------------------------------------
        ; Add base
        ;------------------------------------------------------
idx.pointer.get.addbase:
        ai    tmp1,edb.top          ; Add base of editor buffer
        mov   tmp1,@outparm1        ; Index slot -> Pointer        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.pointer.get.exit:
        b     @poprt                ; Return to caller

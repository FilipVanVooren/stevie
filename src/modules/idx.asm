* FILE......: idx.asm
* Purpose...: TiVi Editor - Index module

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////

***************************************************************
* The index contains 2 major parts:
*
* 1) Main index (c000 - cfff)
*
*    Size of index page is 4K and allows indexing of 2048 lines.
*    Each index slot (1 word) contains the pointer to the line
*    in the editor buffer.
* 
* 2) Shadow SAMS pages index (d000 - dfff)
*
*    Size of index page is 4K and allows indexing of 2048 lines.
*    Each index slot (1 word) contains the SAMS page where the
*    line in the editor buffer resides
*
*  
* The editor buffer itself always resides at (e000 -> ffff) for 
* a total of 8kb.
* First line in editor buffer starts at offset 2 (c002), this
* allows the index to contain "null" pointers, aka empty lines
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
        ; Clear index
        ;------------------------------------------------------
        bl    @film
        data  idx.top,>00,idx.size  ; Clear main index

        bl    @film
        data  idx.shadow.top,>00,idx.shadow.size  
                                    ; Clear shadow index
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
* @parm3    = SAMS page
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
        jeq   idx.entry.update.save ; Special handling for empty line

        ;------------------------------------------------------
        ; SAMS bank
        ;------------------------------------------------------ 
        mov   @parm3,tmp2           ; Get SAMS page

        ;------------------------------------------------------
        ; Update index slot
        ;------------------------------------------------------      
idx.entry.update.save:        
        sla   tmp0,1                ; line number * 2
        mov   tmp1,@idx.top(tmp0)   ; Update index slot -> Pointer
        mov   tmp2,@idx.shadow.top(tmp0)
                                    ; Update SAMS page
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
        jmp   idx.entry.delete.lastline
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @idx.top+2(tmp0),@idx.top+0(tmp0)
        mov   @idx.shadow.top+2(tmp0),@idx.shadow.top+0(tmp0)
        inct  tmp0                  ; Next index entry
        dec   tmp2                  ; tmp2--
        jne   idx.entry.delete.reorg
                                    ; Loop unless completed
        ;------------------------------------------------------
        ; Last line 
        ;------------------------------------------------------      
idx.entry.delete.lastline
        clr   @idx.top(tmp0)
        clr   @idx.shadow.top(tmp0)                
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
                                    ; Move pointer
        clr   @idx.top+0(tmp0)      ; Clear new index entry

        mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
                                    ; Move SAMS page         
        clr   @idx.shadow.top+0(tmp0) 
                                    ; Clear new index entry
        jmp   idx.entry.insert.exit
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.insert.reorg:
        inct  tmp2                  ; Adjust one time

!       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
                                    ; Move pointer

        mov   @idx.shadow.top+0(tmp0),@idx.shadow.top+2(tmp0)
                                    ; Move SAMS page

        dect  tmp0                  ; Previous index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed

        clr   @idx.top+4(tmp0)      ; Clear new index entry
        clr   @idx.shadow.top+4(tmp0) 
                                    ; Clear new index entry
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.insert.exit:
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
* @outparm2 = SAMS page
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
        mov   @idx.top(tmp0),tmp1   ; Get pointer
        mov   @idx.shadow.top(tmp0),tmp2   
                                    ; Get SAMS page
        ;------------------------------------------------------
        ; Return parameter
        ;------------------------------------------------------
idx.pointer.get.parm:
        mov   tmp1,@outparm1        ; Index slot -> Pointer        
        mov   tmp2,@outparm2        ; Index slot -> SAMS page
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.pointer.get.exit:
        b     @poprt                ; Return to caller
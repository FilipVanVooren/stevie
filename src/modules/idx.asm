* FILE......: idx.asm
* Purpose...: TiVi Editor - Index module

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////

***************************************************************
*  Size of index page is 4K and allows indexing of 2048 lines
*  per page.
* 
*  Each index slot (word) has the format:
*    +-----+-----+
*    | MSB | LSB |   
*    +-----|-----+   LSB = Pointer offset 00-ff.
*                      
*  MSB = SAMS Page 00-ff
*        Allows addressing of up to 256 4K SAMS pages (1024 KB)
*    
*  LSB = Pointer offset in range 00-ff
*
*        To calculate pointer to line in Editor buffer:
*        Pointer address = edb.top + (LSB * 16)
*
*        Note that the editor buffer itself resides in own 4K memory range
*        starting at edb.top
*
*        All support routines must assure that length-prefixed string in
*        Editor buffer always start on a 16 byte boundary for being
*        accessible via index.
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
        ; Clear index page
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
* @parm3    = SAMS page
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Pointer to updated index entry
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
idx.entry.update:        
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
        ; Calculate MSB value index slot (SAMS page)
        ;------------------------------------------------------      
        swpb  @parm3
        movb  @parm3,tmp1           ; Put SAMS page in MSB
        ;------------------------------------------------------
        ; Update index slot
        ;------------------------------------------------------      
idx.entry.update.save:        
        sla   tmp0,1                ; line number * 2
        mov   tmp1,@idx.top(tmp0)   ; Update index slot
        jmp   idx.entry.update.exit
        ;------------------------------------------------------
        ; Special handling for "null"-pointer
        ;------------------------------------------------------      
idx.entry.update.clear:
        sla   tmp0,1                ; line number * 2
        clr   @idx.top(tmp0)        ; Clear index slot
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
        inct  tmp0                  ; Next index entry
        dec   tmp2                  ; tmp2--
        jne   idx.entry.delete.reorg
                                    ; Loop unless completed
        ;------------------------------------------------------
        ; Last line 
        ;------------------------------------------------------      
idx.entry.delete.lastline:
        clr   @idx.top(tmp0)
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
                                    ; Move index entry
        clr   @idx.top+0(tmp0)      ; Clear new index entry

        jmp   idx.entry.insert.exit
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.insert.reorg:
        inct  tmp2                  ; Adjust one time

!       mov   @idx.top+0(tmp0),@idx.top+2(tmp0)
                                    ; Move index entry

        dect  tmp0                  ; Previous index entry
        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed

        clr   @idx.top+4(tmp0)      ; Clear new index entry
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
        ; Get slot entry
        ;------------------------------------------------------      
        mov   @parm1,tmp0           ; Line number in editor buffer        
        sla   tmp0,1                ; line number * 2
        mov   @idx.top(tmp0),tmp1   ; Get slot entry
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
        b     @poprt                ; Return to caller
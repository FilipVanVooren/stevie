* FILE......: index.asm
* Purpose...: TiVi Editor - Index module

*//////////////////////////////////////////////////////////////
*                  TiVi Editor - Index Management
*//////////////////////////////////////////////////////////////


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
*--------------------------------------------------------------
* Notes
* Each index slot entry 4 bytes each
*  Word 0: pointer to string (no length byte)
*  Word 1: MSB=Packed length, LSB=Unpacked length
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
idx.init.$$:        
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
*             (or line content if length <= 2)
* @parm3    = Length of line
* @parm4    = SAMS bank
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
        ; Calculate address of index entry and update
        ;------------------------------------------------------      
        sla   tmp0,2                ; line number * 4
        mov   @parm2,@idx.top(tmp0) ; Update index slot -> Pointer
        ;------------------------------------------------------
        ; Put SAMS bank and length of string into index
        ;------------------------------------------------------
        mov   @parm3,tmp1           ; Put line length in LSB tmp1

        mov   @parm4,tmp2           ; \
        swpb  tmp2                  ; | Put SAMS bank in MSB tmp1
        movb  tmp2,tmp1             ; / 

        mov   tmp1,@idx.top+2(tmp0) ; Update index slot -> SAMS Bank/Length
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.update.$$:
        mov   tmp0,@outparm1        ; Pointer to update index entry
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
        sla   tmp0,2                ; line number * 4
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
        seto  @idx.top+0(tmp0)
        clr   @idx.top+2(tmp0)
        jmp   idx.entry.delete.$$
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.delete.reorg:
        mov   @idx.top+4(tmp0),@idx.top+0(tmp0)
        mov   @idx.top+6(tmp0),@idx.top+2(tmp0)
        ai    tmp0,4                ; Next index entry

        dec   tmp2                  ; tmp2--
        jne   idx.entry.delete.reorg
                                    ; Loop unless completed
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------      
idx.entry.delete.$$:
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
        sla   tmp0,2                ; line number * 4
        ;------------------------------------------------------
        ; Prepare for index reorg
        ;------------------------------------------------------
        mov   @parm2,tmp2           ; Get last line to check
        s     @parm1,tmp2           ; Calculate loop 
        jne   idx.entry.insert.reorg
        ;------------------------------------------------------
        ; Special treatment if last line
        ;------------------------------------------------------
        mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
        mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
        clr   @idx.top+0(tmp0)      ; Clear new index entry word 1
        clr   @idx.top+2(tmp0)      ; Clear new index entry word 2
        jmp   idx.entry.insert.$$
        ;------------------------------------------------------
        ; Reorganize index entries 
        ;------------------------------------------------------
idx.entry.insert.reorg:
        inct  tmp2                  ; Adjust one time
!       mov   @idx.top+0(tmp0),@idx.top+4(tmp0)
        mov   @idx.top+2(tmp0),@idx.top+6(tmp0)
        ai    tmp0,-4               ; Previous index entry

        dec   tmp2                  ; tmp2--
        jne   -!                    ; Loop unless completed
        clr   @idx.top+8(tmp0)      ; Clear new index entry word 1
        clr   @idx.top+10(tmp0)     ; Clear new index entry word 2
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
* @outparm2 = Line length
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
        sla   tmp0,2                     ; line number * 4
        mov   @idx.top(tmp0),@outparm1   ; Index slot -> Pointer
        ;------------------------------------------------------
        ; Get SAMS page
        ;------------------------------------------------------      
        mov   @idx.top+2(tmp0),tmp1 ; SAMS Page
        srl   tmp1,8                ; Right justify
        mov   tmp1,@outparm2            
        ;------------------------------------------------------
        ; Get line length
        ;------------------------------------------------------      
        mov   @idx.top+2(tmp0),tmp1 
        andi  tmp1,>00ff            ; Get rid of MSB (SAMS page) 
        mov   tmp1,@outparm3
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.pointer.get.$$:
        b     @poprt                ; Return to caller

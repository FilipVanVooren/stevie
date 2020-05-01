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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
        li    tmp0,idx.top
        mov   tmp0,@edb.index.ptr   ; Set pointer to index in editor structure

        mov   @tv.sams.c000,tmp0
        mov   tmp0,@idx.sams.page   ; Set current SAMS page
        mov   tmp0,@idx.sams.lopage ; Set 1st SAMS page
        mov   tmp0,@idx.sams.hipage ; Set last SAMS page
        ;------------------------------------------------------
        ; Clear index page
        ;------------------------------------------------------
        bl    @film
              data idx.top,>00,idx.size  
                                    ; Clear index
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx.init.exit:        
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller



***************************************************************
* idx._samspage.get
* Get SAMS page for index
***************************************************************
* bl @idx._samspage.get
*--------------------------------------------------------------
* INPUT
* tmp0 = Line number
*--------------------------------------------------------------
* OUTPUT
* @outparm1 = Offset for index entry in index SAMS page
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside idx module.
*  Activate SAMS page containing required index slot entry.
*--------------------------------------------------------------
idx._samspage.get:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Determine SAMS index page
        ;------------------------------------------------------
        mov   tmp0,tmp2             ; Line number
        clr   tmp1                  ; MSW (tmp1) = 0 / LSW (tmp2) = Line number
        li    tmp0,2048             ; Index entries in 4K SAMS page

        div   tmp0,tmp1             ; \ Divide 32 bit value by 2048
                                    ; | tmp1 = quotient  (SAMS page offset)
                                    ; / tmp2 = remainder

        sla   tmp2,1                ; line number * 2                                    
        mov   tmp2,@outparm1        ; Offset index entry

        a     @idx.sams.lopage,tmp1 ; Add SAMS page base
        c     tmp1,@idx.sams.page   ; Page already active?

        jeq   idx._samspage.get.exit
                                    ; Yes, so exit
        ;------------------------------------------------------
        ; Activate SAMS index page
        ;------------------------------------------------------
        mov   tmp1,@idx.sams.page   ; Set current SAMS page
        mov   tmp1,@tv.sams.c000    ; Also keep SAMS window synced in TiVi

        mov   tmp1,tmp0             ; Destination SAMS page
        li    tmp1,>c000            ; Memory window for index page

        bl    @xsams.page.set       ; Switch to SAMS page
                                    ; \ i  tmp0 = SAMS page
                                    ; / i  tmp1 = Memory address
        ;------------------------------------------------------
        ; Check if new highest SAMS index page
        ;------------------------------------------------------
        c     tmp0,@idx.sams.hipage ; New highest page?        
        jle   idx._samspage.get.exit 
                                    ; No, exit
        mov   tmp0,@idx.sams.hipage ; Yes, set highest SAMS index page        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
idx._samspage.get.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller


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
        ;------------------------------------------------------
        ; Update index slot
        ;------------------------------------------------------      
idx.entry.update.save:
        bl    @idx._samspage.get    ; Get SAMS page for index
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
        bl    @idx._samspage.get    ; Get SAMS page for index
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

        bl    @idx._samspage.get    ; Get SAMS page with index slot
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

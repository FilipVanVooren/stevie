* FILE......: fb.insert.line.asm
* Purpose...: Insert a new line

***************************************************************
* fb.insert.line.asm
* Logic for inserting a new line
***************************************************************
* bl @fb.insert.line
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
fb.insert.line:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
        seto  @edb.dirty            ; Editor buffer dirty (text changed!)        
        ;-------------------------------------------------------
        ; Crunch current line if dirty
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   fb.insert.line.insert
        bl    @edb.line.pack.fb     ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Insert entry in index
        ;-------------------------------------------------------
fb.insert.line.insert:        
        bl    @fb.calc_pointer      ; Calculate position in frame buffer
        mov   @fb.topline,@parm1    
        a     @fb.row,@parm1        ; Line number to insert
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        
        bl    @idx.entry.insert     ; Reorganize index
                                    ; \ i  parm1 = Line for insert
                                    ; / i  parm2 = Last line to reorg

        inc   @edb.lines            ; One line added to editor buffer
        clr   @fb.row.length        ; Current row length = 0
        ;-------------------------------------------------------
        ; Check/Adjust marker M1
        ;-------------------------------------------------------
fb.insert.line.m1:        
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   fb.insert.line.m2
                                    ; Yes, skip to M2 check

        c     @parm1,@edb.block.m1
        jgt   fb.insert.line.m2
        inc   @edb.block.m1         ; M1++
        seto  @fb.colorize          ; Set colorize flag                
        ;-------------------------------------------------------
        ; Check/Adjust marker M2
        ;-------------------------------------------------------
fb.insert.line.m2:                
        c     @edb.block.m2,@w$ffff ; Marker M1 unset?
        jeq   fb.insert.line.refresh
                                    ; Yes, skip to refresh frame buffer

        c     @parm1,@edb.block.m2
        jgt   fb.insert.line.refresh
        inc   @edb.block.m2         ; M2++
        seto  @fb.colorize          ; Set colorize flag                
        ;-------------------------------------------------------
        ; Refresh frame buffer and physical screen
        ;-------------------------------------------------------
fb.insert.line.refresh:        
        mov   @fb.topline,@parm1

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)        

        seto  @fb.dirty             ; Trigger screen refresh
        bl    @fb.cursor.home       ; Move cursor home
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
fb.insert.line.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
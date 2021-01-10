* FILE......: edb.line.del.asm
* Purpose...: Delete line in editor buffer

***************************************************************
* edb.line.del
* Delete line in editor buffer
***************************************************************
*  bl   @edb.line.del
*--------------------------------------------------------------
* INPUT
* @parm1 = line number in editor buffer
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Remarks
* @parm1 must be provided in base 1, but internally we work 
* with base 0!
********|*****|*********************|**************************
edb.line.del:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Sanity check
        ;------------------------------------------------------
        c     @parm1,@edb.lines     ; Line beyond editor buffer ?
        jle   !
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system
        ;------------------------------------------------------
        ; Initialize
        ;------------------------------------------------------
!       seto  @edb.dirty            ; Editor buffer dirty (text changed!)
        ;-------------------------------------------------------
        ; Special treatment if only 1 line in editor buffer
        ;-------------------------------------------------------
         mov   @edb.lines,tmp0      ; \ 
         ci    tmp0,1               ; | Only single line? 
         jeq   edb.line.del.1stline ; / Yes, handle single line and exit
        ;-------------------------------------------------------
        ; Delete entry in index
        ;-------------------------------------------------------
        dec   @parm1                ; Base 0
        mov   @edb.lines,@parm2     ; Last line to reorganize 

        bl    @idx.entry.delete     ; Delete entry in index
                                    ; \ i  @parm1 = Line in editor buffer
                                    ; / i  @parm2 = Last line for index reorg  

        dec   @edb.lines            ; One line less in editor buffer            
        ;-------------------------------------------------------
        ; Adjust M1 if set and line number < M1
        ;-------------------------------------------------------
edb.line.del.m1:        
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   edb.line.del.m2       ; Yes, skip to M2

        c     @parm1,@edb.block.m1  ; \
        jeq   edb.line.del.m2       ; | Skip to M2 if line number >= M1
        jgt   edb.line.del.m2       ; /

        c     @edb.block.m1,@w$0001 ; \ 
        jeq   edb.line.del.m2       ; / Skip to M2 if M1 == 1

        dec   @edb.block.m1         ; M1--
        seto  @fb.colorize          ; Set colorize flag                
        ;-------------------------------------------------------
        ; Adjust M2 if set and line number < M2
        ;-------------------------------------------------------
edb.line.del.m2:
        c     @edb.block.m2,@w$ffff ; Marker M2 unset?
        jeq   edb.line.del.exit     ; Yes, exit early

        c     @parm1,@edb.block.m2  ; \
        jeq   edb.line.del.exit     ; | Skip to exit if line number >= M2
        jgt   edb.line.del.exit     ; /

        c     @edb.block.m2,@w$0001 ; \ 
        jeq   edb.line.del.exit     ; / Skip to exit if M1 == 1

        dec   @edb.block.m2         ; M2--
        seto  @fb.colorize          ; Set colorize flag                
        jmp   edb.line.del.exit     ; Exit early
        ;-------------------------------------------------------
        ; Special treatment if only 1 line in editor buffer
        ;-------------------------------------------------------        
edb.line.del.1stline:
        clr   @parm1                ; 1st line
        clr   @parm2                ; 1st line

        bl    @idx.entry.delete     ; Delete entry in index
                                    ; \ i  @parm1 = Line in editor buffer
                                    ; / i  @parm2 = Last line for index reorg
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.line.del.exit:
        mov   *stack+,tmp0          ; Pop tmp0                
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return to caller

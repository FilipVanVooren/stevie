* FILE......: edb.block.del.asm
* Purpose...: Delete code block

***************************************************************
* edb.block.delete
* Delete code block
***************************************************************
*  bl   @edb.block.delete
*--------------------------------------------------------------
* INPUT
* NONE
*--------------------------------------------------------------
* OUTPUT
* NONE
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
edb.block.delete:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Prepare for delete
        ;------------------------------------------------------
        mov   @edb.block.m1,tmp1
        mov   @edb.block.m2,tmp2
        s     tmp1,tmp2
        ci    tmp2,0
        jgt   edb.block.delete.loop
        ;------------------------------------------------------
        ; Copy code block
        ;------------------------------------------------------
edb.block.delete.loop:        
        mov   @edb.lines,@parm2     ; Last line to reorganize 
        dec   @parm2                ; Base 0 offset
        
        bl    @idx.entry.delete     ; Reorganize index
                                    ; \ i  parm1 = Line in editor buffer
                                    ; / i  parm2 = Last line for index reorg

        dec   @edb.lines            ; One line removed from editor buffer

        dec   tmp2
        jgt   edb.block.delete.loop ; Next line
        

        seto  @edb.dirty

        bl    @fb.refresh           ; Refresh frame buffer
        seto  @fb.dirty
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
edb.block.delete.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11  
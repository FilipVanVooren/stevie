* FILE......: idx.insert.asm
* Purpose...: stevie Editor - Insert index slot

*//////////////////////////////////////////////////////////////
*                  stevie Editor - Index Management
*//////////////////////////////////////////////////////////////


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

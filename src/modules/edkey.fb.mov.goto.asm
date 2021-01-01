* FILE......: edkey.fb.mov.goto.asm
* Purpose...: Goto specified line in editor buffer

***************************************************************
* _edkey.goto.fb.toprow
*
* Position cursor on first row in frame buffer and 
* align variables in editor buffer to match with that position.
*
* Internal method that needs to be called via jmp or branch
* instruction. 
***************************************************************
* b    _edkey.goto.fb.toprow
* jmp  _edkey.goto.fb.toprow
*--------------------------------------------------------------
* INPUT
* @parm1  = Line in editor buffer to display as top row (goto)
*
* Register usage
* none
*--------------------------------------------------------------
*  Remarks
*  Private, only to be called from inside edkey submodules
********|*****|*********************|**************************
_edkey.goto.fb.toprow:
        seto  @fb.status.dirty      ; Trigger refresh of status lines

        bl    @fb.refresh           ; \ Refresh frame buffer
                                    ; | i  @parm1 = Line to start with
                                    ; /             (becomes @fb.topline)

        clr   @fb.row               ; Frame buffer line 0
        clr   @fb.column            ; Frame buffer column 0     
        clr   @wyx                  ; Set VDP cursor on row 0, column 0

        bl    @fb.calc_pointer      ; Calculate position in frame buffer

        bl    @edb.line.getlength2  ; \ Get length current line
                                    ; | i  @fb.row        = Row in frame buffer
                                    ; / o  @fb.row.length = Length of row

        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Goto specified line (@parm1) in editor buffer
*---------------------------------------------------------------
edkey.action.goto:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.goto.refresh

        dect  stack
        mov   @parm1,*stack         ; Push parm1
        bl    @edb.line.pack        ; Copy line to editor buffer
        mov   *stack+,@parm1        ; Pop parm1

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.goto.refresh:        
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        b     @_edkey.goto.fb.toprow ; Position cursor and exit
                                     ; \ i  @parm1 = Line in editor buffer
                                     ; /
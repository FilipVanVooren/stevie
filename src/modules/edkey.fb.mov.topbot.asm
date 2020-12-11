* FILE......: edkey.fb.mov.topbot.asm
* Purpose...: Move to top / bottom in editor buffer

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
* Goto top of file
*---------------------------------------------------------------
edkey.action.top:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.top.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.top.refresh:        
        clr   @parm1                ; Set to 1st line in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer




*---------------------------------------------------------------
* Goto bottom of file
*---------------------------------------------------------------
edkey.action.bot:
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.bot.refresh
        bl    @edb.line.pack        ; Copy line to editor buffer
        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Refresh page
        ;-------------------------------------------------------
edkey.action.bot.refresh:        
        c     @edb.lines,@fb.scrrows                                    
        jle   edkey.action.bot.exit ; Skip if whole editor buffer on screen

        mov   @edb.lines,tmp0
        s     @fb.scrrows,tmp0
        mov   tmp0,@parm1           ; Set to last page in editor buffer
        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)        

        jmp   _edkey.goto.fb.toprow ; \ Position cursor and exit
                                    ; / i  @parm1 = Line in editor buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.bot.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
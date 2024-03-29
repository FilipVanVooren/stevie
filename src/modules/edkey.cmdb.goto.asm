* FILE......: edkey.cmdb.goto.asm
* Purpose...: Actions in Goto dialog

*---------------------------------------------------------------
* Goto line
*---------------------------------------------------------------
edkey.action.cmdb.goto:
        ;-------------------------------------------------------        
        ; Exit on empty input string
        ;-------------------------------------------------------
        bl    @cmdb.cmd.getlength   ; Get length of current command
        mov   @outparm1,tmp0        ; Length == 0 ?
        jeq   edkey.action.cmdb.goto.exit
                                    ; Yes, exit
        ;-------------------------------------------------------        
        ; Scan input line number and pack as uint16
        ;-------------------------------------------------------
        li    tmp0,cmdb.cmd         ; \ Pointer to command
        mov   tmp0,@parm1           ; / (no length-byte prefix)

        bl    @tv.uint16.pack       ; Pack string to 16bit unsigned integer
                                    ; \ i  @parm1 = Pointer to input string
                                    ; |             (no length-byte prefix)
                                    ; | 
                                    ; | o  @outparm1 = 16bit unsigned integer
                                    ; | o  @outparm2 = 0 conversion ok, 
                                    ; /                >FFFF invalid input

        ;-------------------------------------------------------        
        ; Assert - Line number could not be parsed
        ;-------------------------------------------------------
        c     @outparm2,@w$ffff     ; Invalid number?
        jeq   edkey.action.cmdb.goto.exit
                                    ; Yes, exit
        ;-------------------------------------------------------        
        ; Prepare for goto
        ;-------------------------------------------------------
edkey.action.cmdb.goto.prepare:
        dect  stack
        mov   @outparm1,*stack      ; Push @outparm1

        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Crunch current row if dirty 
        ;-------------------------------------------------------
        c     @fb.row.dirty,@w$ffff
        jne   edkey.action.cmdb.goto.line

        bl    @edb.line.pack.fb     ; Copy line to editor buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; | i   @fb.column   = Current column in FB
                                    ; / i   @fb.colsline = Cols per line in FB

        clr   @fb.row.dirty         ; Current row no longer dirty
        ;-------------------------------------------------------
        ; Goto line
        ;-------------------------------------------------------
edkey.action.cmdb.goto.line:        
        mov   *stack+,@parm1        ; Pop @outparm1 as @parm1
        dec   @parm1                ; Base 0 offset in editor buffer

        seto  @fb.colorize          ; Colorize M1/M2 marked lines (if present)

        clr   @parm2                ; No row offset in frame buffer

        b     @edkey.fb.goto.toprow ; \ Position cursor and exit
                                    ; | i  @parm1 = Top line in editor buffer
                                    ; / i  @parm2 = Row offset in frame buffer
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
edkey.action.cmdb.goto.exit:        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

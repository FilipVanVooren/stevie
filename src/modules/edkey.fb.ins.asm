* FILE......: edkey.fb.ins.asm
* Purpose...: Insert related actions in frame buffer pane.

*---------------------------------------------------------------
* Insert character
*
* @parm1 = high byte has character to insert
*---------------------------------------------------------------
edkey.action.ins_char.ws:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.ins_char.ws.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Insert character
        ;-------------------------------------------------------
        mov   @edkey.actions.ins.char.ws.data,@parm1
                                    ; White space, freeze cursor

        bl    @fb.insert.char       ; Insert character
                                    ; \ i  @parm1 = MSB character to insert
                                    ; |             LSB = 0 move cursor right
                                    ; /             LSB > 0 do not move cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_char.ws.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main
edkey.actions.ins.char.ws.data:   
        data  >20ff

*---------------------------------------------------------------
* Insert new line on current line
*---------------------------------------------------------------
edkey.action.ins_line:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.ins_line.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Insert line
        ;-------------------------------------------------------
        clr   @parm1                ; Insert new line on curren line
        
        bl    @fb.insert.line       ; Insert empty line
                                    ; \ i  @parm1 = 0 for insert current line
                                    ; /            >0 for insert following line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_line.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


*---------------------------------------------------------------
* Insert new line on following line
*---------------------------------------------------------------
edkey.action.ins_line_after:
        ;-------------------------------------------------------
        ; Skip if editor buffer is locked
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor buffer locked?
        jne   edkey.action.ins_line_after.exit
                                    ; Yes, exit
        ;-------------------------------------------------------
        ; Insert line on following line
        ;-------------------------------------------------------
        seto  @parm1                ; Insert new line on following line

        bl    @fb.insert.line       ; Insert empty line
                                    ; \ i  @parm1 = 0 for insert current line
                                    ; /            >0 for insert following line
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.ins_line_after.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

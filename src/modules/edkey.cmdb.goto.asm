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
        mov   tmp0,@parm1           ; / (skipped length-prefix)

        bl    @tv.uint16.pack       ; Pack string to 16bit unsigned integer
                                    ; \ i  @parm1 = Pointer to input string
                                    ; /             (no length-byte prefix)

        c     @uint16.packed,@w$ffff
                                   ; Invalid number?
        jeq   edkey.action.cmdb.goto.exit
                                   ; Yes, exit
        ;-------------------------------------------------------        
        ; Goto line
        ;-------------------------------------------------------
edkey.action.cmdb.goto.line:
        bl    @cmdb.dialog.close    ; Close dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------        
edkey.action.cmdb.goto.exit:        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

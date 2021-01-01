* FILE......: edkey.fb.block.asm
* Purpose...: Mark lines for block operations

*---------------------------------------------------------------
* Mark line M1
********|*****|*********************|**************************
edkey.action.block.mark.m1:
        bl    @edb.block.mark.m1    ; Set M1 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main
        


*---------------------------------------------------------------
* Mark line M2
********|*****|*********************|**************************
edkey.action.block.mark.m2:
        bl    @edb.block.mark.m2    ; Set M2 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Mark line M1 or M2
********|*****|*********************|**************************
edkey.action.block.mark:
        bl    @edb.block.mark       ; Set M1/M2 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Reset block markers M1/M2
********|*****|*********************|**************************
edkey.action.block.reset:
        bl    @pane.errline.hide    ; Hide error line if visible
        bl    @edb.block.reset      ; Reset block markers M1/M2
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Copy code block
********|*****|*********************|**************************
edkey.action.block.copy:
        bl    @pane.errline.hide    ; Hide error line if visible
        bl    @edb.block.copy       ; Copy code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        b     @_edkey.goto.fb.toprow
                                    ; Position on top row in frame buffer
                                    ; \ i  @parm1 = Line to display as top row
                                    ; /

*---------------------------------------------------------------
* Delete code block
********|*****|*********************|**************************
edkey.action.block.delete:
        bl    @pane.errline.hide    ; Hide error message if visible
        bl    @edb.block.delete     ; Delete code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1
        b     @_edkey.goto.fb.toprow
                                    ; Position on top row in frame buffer
                                    ; \ i  @parm1 = Line to display as top row
                                    ; /



*---------------------------------------------------------------
* Goto marker M1
********|*****|*********************|**************************
edkey.action.block.goto.m1:
        c     @edb.block.m1,@w$0000 ; Marker M1 unset?
        jeq   edkey.action.block.goto.m1.exit
                                    ; Yes, exit early
        ;-------------------------------------------------------
        ; Goto marker M1
        ;-------------------------------------------------------
        mov   @edb.block.m1,@parm1   
        dec   @parm1                ; Base 0 offset 

        b     @edkey.action.goto    ; Goto specified line in editor bufer
                                    ; \ i @parm1 = Target line in EB
                                    ; /
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.goto.m1.exit:  
        b     @hook.keyscan.bounce  ; Back to editor main
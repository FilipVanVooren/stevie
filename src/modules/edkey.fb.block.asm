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
* Reset block markers M1/M2
********|*****|*********************|**************************
edkey.action.block.reset:
        bl    @edb.block.reset      ; Reset block markers M1/M2
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Copy code block
********|*****|*********************|**************************
edkey.action.block.copy:
        bl    @edb.block.copy       ; Copy code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        b     @hook.keyscan.bounce  ; Back to editor main


*---------------------------------------------------------------
* Delete code block
********|*****|*********************|**************************
edkey.action.block.delete:
        bl    @edb.block.delete     ; Delete code block
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
        mov   @fb.topline,@parm1

        b     @_edkey.goto.fb.toprow ; Position on top row in frame buffer
                                     ; \ i  @parm1 = Line to display as top row
                                     ; /

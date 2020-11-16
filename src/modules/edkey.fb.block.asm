* FILE......: edkey.fb.block.asm
* Purpose...: Mark lines for block operations

*---------------------------------------------------------------
* Mark line M1
********|*****|*********************|**************************
edkey.action.block.mark.m1:
        bl    @edb.line.mark.m1     ; Set M1 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.mark.m1.exit:
        b     @hook.keyscan.bounce  ; Back to editor main
        


*---------------------------------------------------------------
* Mark line M2
********|*****|*********************|**************************
edkey.action.block.mark.m2:
        bl    @edb.line.mark.m2     ; Set M1 marker
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.block.mark.m2.exit:
        b     @hook.keyscan.bounce  ; Back to editor main



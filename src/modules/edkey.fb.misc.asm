* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.


*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit


*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
edkey.action.about:
        li    tmp0,>4a4a
        mov   tmp0,@tv.pane.about   ; Indicate FCTN-7 call

        bl    @dialog.about
        b     @hook.keyscan.bounce  ; Back to editor main

*---------------------------------------------------------------
* No action at all
*---------------------------------------------------------------
edkey.action.noop:
        b     @hook.keyscan.bounce  ; Back to editor main

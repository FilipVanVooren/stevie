* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.

*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        ;-------------------------------------------------------
        ; Show dialog "unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   !
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Quit Stevie
        ;-------------------------------------------------------
!       b     @tv.quit





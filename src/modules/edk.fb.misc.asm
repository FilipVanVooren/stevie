* FILE......: edk.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.

*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edk.act.quit:
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


*---------------------------------------------------------------
* Copy code block or open "Insert from clipboard" dialog
*---------------------------------------------------------------
edk.act.copyblock_or_clipboard:
        c     @edb.block.m1,@w$ffff ; Marker M1 unset?
        jeq   !
        b     @edk.act.block.copy
                                    ; Copy code block
!       b     @dialog.clipboard     ; Open "Insert from clipboard" dialog

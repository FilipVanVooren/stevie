* FILE......: edkey.fb.misc.asm
* Purpose...: Actions for miscelanneous keys in frame buffer pane.


*---------------------------------------------------------------
* Quit stevie
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit


*---------------------------------------------------------------
* No action at all
*---------------------------------------------------------------
edkey.action.noop:
        b     @hook.keyscan.bounce  ; Back to editor main






*---------------------------------------------------------------
* Framebuffer down 1 row
*---------------------------------------------------------------
edkey.action.fbdown:
        inc   @fb.scrrows
        seto  @fb.dirty

        b     *r11  


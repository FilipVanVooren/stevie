* FILE......: edkey.misc.asm
* Purpose...: Actions for miscelanneous keys


*---------------------------------------------------------------
* Quit TiVi
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit
        


*---------------------------------------------------------------
* Framebuffer up 1 row
*---------------------------------------------------------------
edkey.action.fbup:
        dec   @fb.screenrows
        seto  @fb.dirty
        bl    *r11


*---------------------------------------------------------------
* Framebuffer down 1 row
*---------------------------------------------------------------
edkey.action.fbdown:
        inc   @fb.screenrows
        seto  @fb.dirty
        bl    *r11

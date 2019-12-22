* FILE......: editorkeys_aux.asm
* Purpose...: Actions for miscelanneous keys


*---------------------------------------------------------------
* Quit TiVi
*---------------------------------------------------------------
edkey.action.quit:
        bl    @f18rst               ; Reset and lock the F18A
        blwp  @0                    ; Exit
        
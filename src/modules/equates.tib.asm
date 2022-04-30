* FILE......: equates.tib.asm
* Purpose...: Equates for TI Basic session

*--------------------------------------------------------------
* Equates mainly used while TI Basic session is running
*--------------------------------------------------------------
tib.aux           equ  >ff00           ; Auxiliary memory 256 bytes
tib.aux.fname     equ  tib.aux         ; TI Basic program filename
tib.aux.end       equ  >fffa           ; \ End of auxiliary memory
                                       ; | >fffc-ffff is reserved 
                                       ; / for NMI vector.
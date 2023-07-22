* FILE......: edkey.cmdb.fíle.directory.asm
* Purpose...: Drive/Directory listing

*---------------------------------------------------------------
* Drive/Directory listing
*---------------------------------------------------------------
edkey.action.cmdb.file.directory:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Catalog drive/directory
        ;-------------------------------------------------------
        li    tmp0,myfile
        mov   tmp0,@parm1
        bl    @fm.directory
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.file.catalog.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

        

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

        
edkey.action.filebrowser.1:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 1
        ;-------------------------------------------------------
        clr   @cat.page             ; Set page 1 (base 0)
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.1.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


edkey.action.filebrowser.2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 2
        ;-------------------------------------------------------
        li    tmp0,1                ; \ Set page 2 (base 0)
        mov   tmp0,@cat.page        ; /
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.2.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


edkey.action.filebrowser.3:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 3
        ;-------------------------------------------------------
        li    tmp0,2                ; \ Set page 3 (base 0)
        mov   tmp0,@cat.page        ; /
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.3.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main                                    

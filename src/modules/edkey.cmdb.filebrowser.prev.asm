* FILE......: edkey.cmdb.filebrowser.prev.asm
* Purpose...: Previous page in filebrowser

edkey.action.filebrowser.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Check page boundaries
        ;-------------------------------------------------------
        mov   @cat.currentpage,tmp0
        ci    tmp0,1                
        jeq   edkey.action.filebrowser.prev.exit
        ;-------------------------------------------------------
        ; Previous page
        ;-------------------------------------------------------
edkey.action.filebrowser.prev.page:        
        s     @cat.nofilespage,@cat.fpicker.idx
        bl    @pane.filebrowser     ; Show filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.prev.exit:
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

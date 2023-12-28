* FILE......: edkey.cmdb.filebrowser.next.asm
* Purpose...: Next page in filebrowser

edkey.action.filebrowser.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Check page boundaries
        ;-------------------------------------------------------
        c     @cat.currentpage,@cat.totalpages
        jeq   edkey.action.filebrowser.next.exit
        ;-------------------------------------------------------
        ; Next page
        ;-------------------------------------------------------
        a     @cat.nofilespage,@cat.fpicker.idx
        bl    @pane.filebrowser     ; Show filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.next.exit:
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

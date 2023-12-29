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
        jne   edkey.action.filebrowser.prev.page
        clr   @cat.fpicker.idx
        jmp   edkey.action.filebrowser.prev.page.display
        ;-------------------------------------------------------
        ; Previous page
        ;-------------------------------------------------------
edkey.action.filebrowser.prev.page:        
        s     @cat.nofilespage,@cat.fpicker.idx
                                    ; Calculate 1st filename on page

        mov   @cat.fpicker.idx,@cat.shortcut.idx
                                    ; Make it same for highlighter

        bl    @pane.filebrowser     ; Show filebrowser                                    
        ;-------------------------------------------------------
        ; Display page
        ;-------------------------------------------------------
edkey.action.filebrowser.prev.page.display:                                                    
        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy filename from command line to buffer
        ;---------------------------------------------------------------
        ; Cursor end of line
        ;---------------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length byte of current command
        srl   tmp0,8                ; Right justify
        mov   tmp0,@cmdb.column     ; Save column position
        inc   tmp0                  ; One time adjustment command prompt        
        swpb  tmp0                  ; LSB TO MSB
        movb  tmp0,@cmdb.cursor+1   ; Set cursor position        

        seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)      
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.prev.exit:
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

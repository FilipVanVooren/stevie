* FILE......: edkey.cmdb.filebrowser.next.asm
* Purpose...: Next page in filebrowser

edkey.action.filebrowser.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Check page boundaries
        ;-------------------------------------------------------
        c     @cat.currentpage,@cat.totalpages
        jlt   edkey.action.filebrowser.next.page
        mov   @cat.totalpages,@cat.currentpage
        jmp   edkey.action.filebrowser.next.page.display
        ;-------------------------------------------------------
        ; Next page
        ;-------------------------------------------------------
edkey.action.filebrowser.next.page:        
        a     @cat.nofilespage,@cat.fpicker.idx
                                    ; Calculate 1st filename on page
        ;-------------------------------------------------------
        ; Display page
        ;-------------------------------------------------------
edkey.action.filebrowser.next.page.display:                
        mov   @cat.fpicker.idx,@cat.shortcut.idx
                                    ; Make it same for highlighter

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        bl    @pane.filebrowser     ; Show filebrowser

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
edkey.action.filebrowser.next.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

* FILE......: edkey.cmdb.filebrowser.nextpage.asm
* Purpose...: Next page in filebrowser

edkey.action.filebrowser.nextpage:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Check page boundaries
        ;-------------------------------------------------------
        c     @cat.currentpage,@cat.totalpages
        jlt   edkey.action.filebrowser.nextpage.page
        mov   @cat.totalpages,@cat.currentpage
        jmp   edkey.action.filebrowser.nextpage.checkdialog
        ;-------------------------------------------------------
        ; Next page
        ;-------------------------------------------------------
edkey.action.filebrowser.nextpage.page:        
        a     @cat.nofilespage,@cat.fpicker.idx
                                    ; Calculate 1st filename on page

        mov   @cat.fpicker.idx,@cat.shortcut.idx
                                    ; Make it same for highlighter

        bl    @pane.filebrowser     ; Show filebrowser
        ;-------------------------------------------------------
        ; Check if on supported dialog for filename display
        ;-------------------------------------------------------
edkey.action.filebrowser.nextpage.checkdialog:
        mov   @cmdb.dialog,tmp0     ; Get current dialog ID

        ci    tmp0,id.dialog.open   ; \ First supported dialog
        jlt   edkey.action.filebrowser.nextpage.exit
                                    ; / Not in supported dialog range. Skip 

        ci    tmp0,id.dialog.run    ; \ Last supported dialog
        jgt   edkey.action.filebrowser.nextpage.exit
                                    ; / Not in supported dialog range. Skip
        ;-------------------------------------------------------
        ; Display device and filename
        ;-------------------------------------------------------
edkey.action.filebrowser.nextpage.page.display:                
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

        bl    @cmdb.refresh_prompt  ; Refresh command line
        bl    @cmdb.cmd.cursor_eol  ; Cursor at end of input
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.nextpage.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

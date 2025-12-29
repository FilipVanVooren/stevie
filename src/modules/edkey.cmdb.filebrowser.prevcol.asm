* FILE......: edkey.cmdb.filebrowser.prevcol.asm
* Purpose...: Previous column in filebrowser

edkey.action.filebrowser.prevcol:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Check column boundaries
        ;-------------------------------------------------------
        mov   @cat.barcol,tmp0      ; Get current column
        jeq   edkey.action.filebrowser.prevcol.exit
                                    ; Already at first column. Skip
        ;-------------------------------------------------------
        ; Next column
        ;-------------------------------------------------------
edkey.action.filebrowser.prevcol.page:        
        s     @cat.nofilescol,@cat.shortcut.idx
                                    ; Calculate filename on page

        bl   @pane.filebrowser.hilight
                                    ; Highlight filename
        ;-------------------------------------------------------
        ; Check if on supported dialog for filename display
        ;-------------------------------------------------------
edkey.action.filebrowser.prevcol.checkdialog:
        mov   @cmdb.dialog,tmp0     ; Get current dialog ID

        ci    tmp0,id.dialog.open   ; \ First supported dialog
        jlt   edkey.action.filebrowser.prevcol.exit
                                    ; / Not in supported dialog range. Skip 

        ci    tmp0,id.dialog.run    ; \ Last supported dialog
        jgt   edkey.action.filebrowser.prevcol.exit
                                    ; / Not in supported dialog range. Skip
        ;-------------------------------------------------------
        ; Display device and filename
        ;-------------------------------------------------------
edkey.action.filebrowser.prevcol.page.display:                
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
edkey.action.filebrowser.prevcol.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

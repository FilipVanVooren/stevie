* FILE......: edk.cmdb.filebrowser.nextcol.asm
* Purpose...: Next column in filebrowser

edk.act.filebrowser.nextcol:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Check column boundaries
        ;-------------------------------------------------------
        mov   @cat.barcol,tmp0      ; Get current column
        ci    tmp0,2                ; Last column ?
        jeq   edk.act.filebrowser.prevcol.exit
                                    ; Already at last column. Skip
        ;-------------------------------------------------------
        ; Check if passing end of file list
        ;-------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0
        a     @cat.nofilescol,tmp0
        c     tmp0,@cat.filecount
        jlt   edk.act.filebrowser.nextcol.page
                                    ; Not passed end of file list. Display
        jmp   edk.act.filebrowser.nextcol.exit
                                    ; Passed end of file list. Skip
        ;-------------------------------------------------------
        ; Next column
        ;-------------------------------------------------------
edk.act.filebrowser.nextcol.page:        
        a     @cat.nofilescol,@cat.shortcut.idx
                                    ; Calculate filename on page

        bl   @pane.filebrowser.hilight
                                    ; Highlight filename
        ;-------------------------------------------------------
        ; Check if on supported dialog for filename display
        ;-------------------------------------------------------
edk.act.filebrowser.nextcol.checkdialog:
        mov   @cmdb.dialog,tmp0     ; Get current dialog ID

        ci    tmp0,id.dialog.open   ; \ First supported dialog
        jlt   edk.act.filebrowser.nextcol.exit
                                    ; / Not in supported dialog range. Skip 

        ci    tmp0,id.dialog.run    ; \ Last supported dialog
        jgt   edk.act.filebrowser.nextcol.exit
                                    ; / Not in supported dialog range. Skip
        ;-------------------------------------------------------
        ; Display device and filename
        ;-------------------------------------------------------
edk.act.filebrowser.nextcol.page.display:                
        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @tv.devpath = Current device name
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
edk.act.filebrowser.nextcol.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

* FILE......: edkey.cmdb.filebrowser.nextcol.asm
* Purpose...: Next column in filebrowser

edkey.action.filebrowser.nextcol:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Check column boundaries
        ;-------------------------------------------------------
        mov   @cat.barcol,tmp0      ; Get current column
        ci    tmp0,2                ; Last column ?
        jeq   edkey.action.filebrowser.prevcol.exit
                                    ; Already at last column. Skip
        ;-------------------------------------------------------
        ; Check if passing end of file list
        ;-------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0
        a     @cat.nofilescol,tmp0
        c     tmp0,@cat.filecount
        jlt   edkey.action.filebrowser.nextcol.page
                                    ; Not passed end of file list. Display
        jmp   edkey.action.filebrowser.nextcol.exit
                                    ; Passed end of file list. Skip
        ;-------------------------------------------------------
        ; Next column
        ;-------------------------------------------------------
edkey.action.filebrowser.nextcol.page:        
        a     @cat.nofilescol,@cat.shortcut.idx
                                    ; Calculate filename on page

        bl   @pane.filebrowser.hilight
                                    ; Highlight filename
        ;-------------------------------------------------------
        ; Check if on supported dialog for filename display
        ;-------------------------------------------------------
edkey.action.filebrowser.nextcol.checkdialog:
        mov   @cmdb.dialog,tmp0     ; Get current dialog ID

        ci    tmp0,id.dialog.load   ; \ First supported dialog
        jlt   edkey.action.filebrowser.nextcol.exit
                                    ; / Not in supported dialog range. Skip 

        ci    tmp0,id.dialog.run    ; \ Last supported dialog
        jgt   edkey.action.filebrowser.nextcol.exit
                                    ; / Not in supported dialog range. Skip
        ;-------------------------------------------------------
        ; Display device and filename
        ;-------------------------------------------------------
edkey.action.filebrowser.nextcol.page.display:                
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
edkey.action.filebrowser.nextcol.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

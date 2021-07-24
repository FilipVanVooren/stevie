* FILE......: edkey.key.process.asm
* Purpose...: Process keyboard key press. Shared code for all panes

****************************************************************
* Editor - Process action keys
****************************************************************
edkey.key.process:
        mov   @waux1,tmp1           ; \ 
        andi  tmp1,>ff00            ; | Get key value and clear LSB
        mov   tmp1,@waux1           ; / 
        seto  tmp3                  ; EOL marker
        ;-------------------------------------------------------
        ; Process key depending on pane with focus
        ;-------------------------------------------------------
        mov   @tv.pane.focus,tmp2
        ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?  
        jeq   edkey.key.process.loadmap.editor
                                    ; Yes, so load editor keymap

        ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
        jeq   edkey.key.process.loadmap.cmdb
                                    ; Yes, so load CMDB keymap
        ;-------------------------------------------------------
        ; Pane without focus, crash
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / File error occured. Halt system.
        ;-------------------------------------------------------
        ; Load Editor keyboard map
        ;-------------------------------------------------------
edkey.key.process.loadmap.editor:        
        li    tmp2,keymap_actions.editor 
        jmp   edkey.key.check.next
        ;-------------------------------------------------------
        ; Load CMDB keyboard map
        ;-------------------------------------------------------
edkey.key.process.loadmap.cmdb:                
        li    tmp2,keymap_actions.cmdb
        ;-------------------------------------------------------
        ; Iterate over keyboard map for matching action key
        ;-------------------------------------------------------
edkey.key.check.next:
        cb    *tmp2,tmp3            ; EOL reached ?
        jeq   edkey.key.process.addbuffer
                                    ; Yes, means no action key pressed, so
                                    ; add character to buffer
        ;-------------------------------------------------------
        ; Check for action key match
        ;-------------------------------------------------------
        cb    tmp1,*tmp2            ; Action key matched?
        jeq   edkey.key.check.scope
                                    ; Yes, check scope
        ;-------------------------------------------------------
        ; If key in range 'a..z' then also check 'A..Z'
        ;-------------------------------------------------------
        ci    tmp1,>6100            ; ASCII 97 'a'
        jlt   edkey.key.check.next.entry

        ci    tmp1,>7a00            ; ASCII 122 'z'
        jgt   edkey.key.check.next.entry        

        ai    tmp1,->2000           ; Make uppercase
        cb    tmp1,*tmp2            ; Action key matched?
        jeq   edkey.key.check.scope
                                    ; Yes, check scope
        ;-------------------------------------------------------
        ; Key is no action key, keep case for later (buffer)
        ;-------------------------------------------------------
        ai    tmp1,>2000            ; Make lowercase

edkey.key.check.next.entry:
        ai    tmp2,4                ; Skip current entry
        jmp   edkey.key.check.next  ; Check next entry
        ;-------------------------------------------------------
        ; Check scope of key
        ;-------------------------------------------------------
edkey.key.check.scope:
        inc   tmp2                  ; Move to scope
        cb    *tmp2,@tv.pane.focus+1 
                                    ; (1) Process key if scope matches pane
        jeq   edkey.key.process.action

        cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
        jeq   edkey.key.process.action
        ;-------------------------------------------------------
        ; Key pressed outside valid scope, ignore action entry
        ;-------------------------------------------------------
        ai    tmp2,3                ; Skip current entry
        mov   @waux1,tmp1           ; Restore original case of key
        jmp   edkey.key.check.next  ; Process next action entry        
        ;-------------------------------------------------------
        ; Trigger keyboard action
        ;-------------------------------------------------------
edkey.key.process.action:
        inc   tmp2                  ; Move to action address
        mov   *tmp2,tmp2            ; Get action address

        li    tmp0,id.dialog.unsaved
        c     @cmdb.dialog,tmp0
        jeq   !                     ; Skip store pointer if in "Unsaved changes"

        mov   tmp2,@cmdb.action.ptr ; Store action address as pointer
!       b     *tmp2                 ; Process key action
        ;-------------------------------------------------------
        ; Add character to editor or cmdb buffer
        ;-------------------------------------------------------
edkey.key.process.addbuffer:
        mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
        jne   !                     ; No, skip frame buffer 
        b     @edkey.action.char    ; Add character to frame buffer        
        ;-------------------------------------------------------
        ; CMDB buffer
        ;-------------------------------------------------------
!       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
        jne   edkey.key.process.crash
                                    ; No, crash
        ;-------------------------------------------------------
        ; Don't add character if dialog has ID >= 100
        ;-------------------------------------------------------
        mov   @cmdb.dialog,tmp0
        ci    tmp0,99
        jgt   edkey.key.process.exit
        ;-------------------------------------------------------
        ; Add character to CMDB
        ;-------------------------------------------------------
        b     @edkey.action.cmdb.char
                                    ; Add character to CMDB buffer        
        ;-------------------------------------------------------
        ; Crash
        ;-------------------------------------------------------
edkey.key.process.crash:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / File error occured. Halt system.
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.key.process.exit:
       b     @hook.keyscan.bounce   ; Back to editor main        

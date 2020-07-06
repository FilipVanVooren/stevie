* FILE......: edkey.asm
* Purpose...: Process keyboard key press. Shared code for all panes


****************************************************************
* Editor - Process action keys
****************************************************************
edkey.key.process:
        mov   @waux1,tmp1           ; Get key value
        andi  tmp1,>ff00            ; Get rid of LSB
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
        jmp   edkey.key.check_next
        ;-------------------------------------------------------
        ; Load CMDB keyboard map
        ;-------------------------------------------------------
edkey.key.process.loadmap.cmdb:                
        li    tmp2,keymap_actions.cmdb
        jne   edkey.key.check_next
        ;-------------------------------------------------------
        ; Iterate over keyboard map for matching action key
        ;-------------------------------------------------------
edkey.key.check_next:
        c     *tmp2,tmp3            ; EOL reached ?
        jeq   edkey.key.process.addbuffer
                                    ; Yes, means no action key pressed, so
                                    ; add character to buffer
        ;-------------------------------------------------------
        ; Check for action key match
        ;-------------------------------------------------------
        c     tmp1,*tmp2            ; Action key matched?
        jeq   edkey.key.process.action
                                    ; Yes, do action
        ai    tmp2,6                ; Skip current entry
        jmp   edkey.key.check_next  ; Check next entry
        ;-------------------------------------------------------
        ; Trigger keyboard action
        ;-------------------------------------------------------
edkey.key.process.action:
        ai    tmp2,4                ; Move to action address
        mov   *tmp2,tmp2            ; Get action address
        b     *tmp2                 ; Process key action
        ;-------------------------------------------------------
        ; Add character to appropriate buffer
        ;-------------------------------------------------------
edkey.key.process.addbuffer:
        mov  @tv.pane.focus,tmp0    ; Frame buffer has focus?
        jne  !                      ; No, skip frame buffer 
        b    @edkey.action.char     ; Add character to frame buffer        
        ;-------------------------------------------------------
        ; CMDB buffer
        ;-------------------------------------------------------
!       ci   tmp0,pane.focus.cmdb   ; CMDB has focus ?
        jne  edkey.key.process.crash
                                    ; No, crash
        b    @edkey.action.cmdb.char
                                    ; Add character to CMDB buffer        
        ;-------------------------------------------------------
        ; Crash
        ;-------------------------------------------------------
edkey.key.process.crash:
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / File error occured. Halt system.

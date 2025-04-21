* FILE......: edkey.key.process.asm
* Purpose...: Process keyboard key press. Shared code for all panes

****************************************************************
* Editor - Process action keys
****************************************************************
edkey.key.process:
        mov   @keycode1,tmp1        ; Get key pressed
        sla   tmp1,8                ; Move to MSB
        seto  tmp3                  ; EOL marker
        ;-------------------------------------------------------
        ; (1) Process key depending on pane with focus
        ;-------------------------------------------------------
        mov   @tv.pane.focus,tmp2
        ci    tmp2,pane.focus.fb    ; Framebuffer has focus ?
        jeq   edkey.key.process.special
                                    ; First check special key combinations

        ci    tmp2,pane.focus.cmdb  ; Command buffer has focus ?
        jeq   edkey.key.process.loadmap.cmdb
                                    ; Yes, so load CMDB keymap
        ;-------------------------------------------------------
        ; Pane without focus, crash
        ;-------------------------------------------------------
        mov   r11,@>ffce            ; \ Save caller address
        bl    @cpu.crash            ; / File error occured. Halt system.
        ;-------------------------------------------------------
        ; (2) Check special key combination
        ;-------------------------------------------------------
edkey.key.process.special:
        ci    tmp1,>2000            ; Space key pressed?
        jne   edkey.key.process.loadmap.editor
                                    ; No, continue with normal checks
        ;-------------------------------------------------------
        ; (2a) Look for <ctrl> key
        ;-------------------------------------------------------
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   r12,*stack            ; Push r12

        clr   tmp0                  ; Keyboard column 0
        li    r12,>0024             ; CRU address decoder
        ldcr  tmp0,3                ; Select column
        li    r12,>0006             ; Address of the first row
        stcr  tmp1,8                ; Read 8 rows
        andi  tmp1,>4000            ; Test ctrl key
        jne   edkey.key.process.special.postprocess
                                    ; No ctrl key pressed
        ;-------------------------------------------------------
        ; <ctrl> + space key pressed
        ;-------------------------------------------------------
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        b     @edkey.action.block.mark
                                    ; Set block M1/M2 marker
        ;-------------------------------------------------------
        ; Postprocessing <ctrl> + space check
        ;-------------------------------------------------------
edkey.key.process.special.postprocess:
        mov   *stack+,r12           ; Pop r12
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;-------------------------------------------------------
        ; (3) Load Editor keyboard map
        ;-------------------------------------------------------
edkey.key.process.loadmap.editor:
        li    tmp2,keymap_actions.editor
        jmp   edkey.key.check.next
        ;-------------------------------------------------------
        ; (4) Load CMDB keyboard map
        ;-------------------------------------------------------
edkey.key.process.loadmap.cmdb:
        li    tmp2,keymap_actions.cmdb
        ;-------------------------------------------------------
        ; (5) Iterate over keyboard map for matching action key
        ;-------------------------------------------------------
edkey.key.check.next:
        cb    *tmp2,tmp3            ; EOL reached ?
        jeq   edkey.key.process.addbuffer
                                    ; Yes, means no action key pressed,
                                    ; so add character to buffer
        ;-------------------------------------------------------
        ; (6) Check for action key match
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
        ; (7) Check scope of key
        ;-------------------------------------------------------
edkey.key.check.scope:
        inc   tmp2                  ; Move to scope
        cb    *tmp2,@tv.pane.focus+1
                                    ; (1) Process key if scope matches pane
        jeq   edkey.key.process.action

        cb    *tmp2,@cmdb.dialog+1  ; (2) Process key if scope matches dialog
        jeq   edkey.key.process.action
        ;-------------------------------------------------------
        ; (8) Key pressed outside valid scope, ignore action entry
        ;-------------------------------------------------------
        ai    tmp2,3                ; Skip current entry
        mov   @keycode1,tmp1        ; Restore original case of key
        sla   tmp1,8                ; Move to MSB
        jmp   edkey.key.check.next  ; Process next action entry
        ;-------------------------------------------------------
        ; (9) Trigger keyboard action
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
        ; (10) Add character to editor or cmdb buffer
        ;-------------------------------------------------------
edkey.key.process.addbuffer:
        mov   @tv.pane.focus,tmp0   ; Frame buffer has focus?
        jne   !                     ; No, skip frame buffer processing
        mov   tmp1,tmp0             ; Get keycode
        bl    @edk.fb.char          ; Add character to frame buffer
                                    ; \ i  tmp0 = Keycode (MSB)
                                    ; /
        jmp   edkey.key.process.exit
        ;-------------------------------------------------------
        ; (11) CMDB buffer
        ;-------------------------------------------------------
!       ci    tmp0,pane.focus.cmdb  ; CMDB has focus ?
        jne   edkey.key.process.crash
                                    ; No, crash
        ;-------------------------------------------------------
        ; Don't add character if dialog has ID >= 100
        ;-------------------------------------------------------
        mov   @cmdb.dialog,tmp0
        ci    tmp0,99
        jgt   edkey.key.process.enter
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
        ; Check ENTER key if ID >= 100 and close pane if match
        ;-------------------------------------------------------
edkey.key.process.enter:
        mov   @keycode1,tmp0        ; Get key
        ci    tmp0,key.space        ; SPACE ?
        jne   edkey.key.process.exit
        b     @edkey.action.cmdb.close.dialog
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.key.process.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

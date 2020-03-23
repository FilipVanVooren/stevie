* FILE......: edkey.asm
* Purpose...: Process keyboard key press


****************************************************************
* Editor - Process action keys
****************************************************************
edkey.key.process:
        mov   @waux1,tmp1           ; Get key value
        andi  tmp1,>ff00            ; Get rid of LSB

        li    tmp2,keymap_actions.editor 
                                    ; Load keyboard map
        seto  tmp3                  ; EOL marker
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
        ; Add character to buffer
        ;-------------------------------------------------------
edkey.key.process.addbuffer:
        b    @edkey.action.char     ; Add character to buffer        
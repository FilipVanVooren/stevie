* FILE......: edkey.fb.file.load.asm
* Purpose...: Load file into editor

***************************************************************
* edkey.action.fb.load.file
* Load file into editor
***************************************************************
* b  @edkey.action.fb.load.file
*--------------------------------------------------------------
* INPUT
* @parm1 = Pointer to filename string
********|*****|*********************|**************************
edkey.action.fb.load.file:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        mov   @parm1,tmp0           ; Pointer to filename set?
        jne   !                     ; Yes, continue
        ;-------------------------------------------------------
        ; No filename specified
        ;-------------------------------------------------------    
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

        jmp   edkey.action.fb.load.file.exit
        ;------------------------------------------------------
        ; Show dialog "Unsaved changed" if editor buffer dirty
        ;------------------------------------------------------
!       mov   @edb.dirty,tmp0
        jeq   edkey.action.fb.load.file.doit
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
edkey.action.fb.load.file.doit:
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.fb.load.file.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @edkey.action.top     ; Goto 1st line in editor buffer 

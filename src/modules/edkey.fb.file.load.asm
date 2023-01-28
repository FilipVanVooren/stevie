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
        jeq   edkey.action.fb.load.check.mastcat
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Special handling Master Catalog
        ;-------------------------------------------------------
edkey.action.fb.load.check.mastcat:
        mov   @edb.special.file,tmp0   ; \ Master catalog previously open?
        ci    tmp0,id.special.mastcat  ; / 

        jne   edkey.action.fb.load.loadfile
                                    ; No, just load file

        mov   @fb.topline,@edb.fb.topline.bk
                                    ; Yes, first save current line position
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
edkey.action.fb.load.loadfile:        
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string
        ;-------------------------------------------------------
        ; Special handling master catalog
        ;-------------------------------------------------------
        mov   @edb.special.file,tmp0
                                    ; Special file?
        
        ci    tmp0,id.special.mastcat
        jne   edkey.action.fb.load.file.exit
        ;-------------------------------------------------------
        ; Goto line in file and exit
        ;-------------------------------------------------------
        mov   @edb.fb.topline.bk,@parm1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.fb.goto.toprow ; Goto specifed line in editor buffer
        ;-------------------------------------------------------
        ; Goto top of file and exit
        ;-------------------------------------------------------
edkey.action.fb.load.file.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.action.top     ; Goto 1st line in editor buffer 

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
* @parm2 = Type of special file to load
********|*****|*********************|**************************
edkey.action.fb.load.file:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        mov   @parm2,tmp1           ; Backup @parm1

        bl    @pane.cmdb.hide       ; Hide CMDB pane

        mov   @parm1,tmp0           ; Pointer to filename set?
        jne   !                     ; Yes, continue
        ;-------------------------------------------------------
        ; Show error "No filename specified"
        ;-------------------------------------------------------    
        li    tmp0,txt.io.nofile    ; \
        mov   tmp0,@parm1           ; / Error message

        bl    @error.display        ; Show error message
                                    ; \ i  @parm1 = Pointer to error message
                                    ; /

        jmp   edkey.action.fb.load.file.exit2
        ;------------------------------------------------------
        ; Show dialog "Unsaved changed" if editor buffer dirty
        ;------------------------------------------------------
!       mov   @edb.dirty,tmp0
        jeq   edkey.action.fb.load.check.mastcat
        jmp   edkey.action.fb.load.file.exit3
        ;-------------------------------------------------------
        ; Special handling Master Catalog
        ;-------------------------------------------------------
edkey.action.fb.load.check.mastcat:
        mov   @edb.special.file,tmp0  ; \ Master catalog previously open?
        ci    tmp0,id.special.mastcat ; / 

        jne   edkey.action.fb.load.loadfile
                                    ; No, just load file

        mov   @fb.topline,@edb.bk.fb.topline
                                    ; Yes, save current line position
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
edkey.action.fb.load.loadfile:        
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string
        ;-------------------------------------------------------
        ; Handle special files
        ;-------------------------------------------------------
        mov   tmp1,@edb.special.file   ; \ Restore @parm2
                                       ; / Set special file (0=normal file)
                                       
        ci    tmp1,id.special.mastcat  ; Is master catalog?
        jne   edkey.action.fb.load.file.exit2
                                       ; No, goto top of file and exit
        ;-------------------------------------------------------
        ; Goto line in file and exit
        ;-------------------------------------------------------
edkey.action.fb.load.file.exit1:        
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11 
        mov   @edb.bk.fb.topline,@parm1
        b     @edkey.fb.goto.toprow ; Goto specifed line in editor buffer
        ;-------------------------------------------------------
        ; Goto top of file (TOF) and exit
        ;-------------------------------------------------------
edkey.action.fb.load.file.exit2:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.action.top     ; Goto 1st line in editor buffer 
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" and exit
        ;-------------------------------------------------------
edkey.action.fb.load.file.exit3:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.action.top     ; Goto 1st line in editor buffer 
        b     @dialog.unsaved       ; Show dialog and exit

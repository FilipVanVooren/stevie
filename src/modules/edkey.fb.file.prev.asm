* FILE......: edkey.fb.file.prev.asm
* Purpose...: File loading actions in frame buffer pane.

*---------------------------------------------------------------
* Load previous file
*---------------------------------------------------------------
* b   @edkey.action.fb.file.prev
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.fb.file.prev:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        bl    @fm.browse.fname.prev ; Previous file in catalog filename list
        mov   @outparm1,tmp0        ; Skipped flag set?
        jne   edkey.action.fb.file.prev.exit
                                    ; Yes, exit early

        li    tmp0,edkey.action.fb.file.prev
        mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
                                    ; in "Unsaved changes" dialog
        ;------------------------------------------------------
        ; Show dialog "Unsaved changed" if editor buffer dirty
        ;------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   edkey.action.fb.file.prev.loadfile
        mov   *stack+,tmp0          ; Pop tmp0         
        b     @dialog.unsaved       ; Show dialog and exit
        ;------------------------------------------------------
        ; Load file
        ;------------------------------------------------------
edkey.action.fb.file.prev.loadfile:        
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        li    tmp0,cat.fullfname    ; \ Get pointer to string with combined
        mov   tmp0,@parm1           ; / device and filename

        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string        
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.fb.file.prev.exit
        mov   *stack+,tmp0          ; Pop tmp0 
        b    @edkey.action.top      ; Goto 1st line in editor buffer

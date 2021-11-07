* FILE......: edkey.fb.fíle.asm
* Purpose...: File related actions in frame buffer pane.

*---------------------------------------------------------------
* Load next or previous file based on last char in suffix
*---------------------------------------------------------------
* b   @edkey.action.fb.fname.inc.load
* b   @edkey.action.fb.fname.dec.load
*--------------------------------------------------------------- 
* INPUT
* @cmdb.cmdlen
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.fb.fname.dec.load:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        clr   @parm2                ; Decrease ASCII value of char in suffix

        li    tmp0,edkey.action.fb.fname.dec.load
        mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
                                    ; in "Unsaved changes" dialog

        jmp   edkey.action.fb.fname.doit


edkey.action.fb.fname.inc.load:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        seto  @parm2                ; Increase ASCII value of char in suffix                

        li    tmp0,edkey.action.fb.fname.inc.load
        mov   tmp0,@cmdb.action.ptr ; Set deferred action to run if proceeding
                                    ; in "Unsaved changes" dialog

        ;------------------------------------------------------
        ; Process filename
        ;------------------------------------------------------
edkey.action.fb.fname.doit:
        mov   @edb.filename.ptr,tmp0 
        jeq   edkey.action.fb.fname.exit
                                    ; Exit early if new file.

        ci    tmp0,txt.newfile
        jeq   edkey.action.fb.fname.exit
                                    ; Exit early if "[New file]"

        mov   tmp0,@parm1           ; Set filename
        ;------------------------------------------------------
        ; Show dialog "Unsaved changed" if editor buffer dirty
        ;------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   !
        mov   *stack+,tmp0          ; Pop tmp0         
        b     @dialog.unsaved       ; Show dialog and exit
        ;------------------------------------------------------
        ; Update suffix
        ;------------------------------------------------------
!       bl    @fm.browse.fname.suffix
                                    ; Filename suffix adjust
                                    ; i  \ parm1 = Pointer to filename
                                    ; i  / parm2 = >FFFF or >0000
        ;------------------------------------------------------
        ; Load file
        ;------------------------------------------------------
edkey.action.fb.fname.doit.loadfile:        
        bl    @pane.cmdb.hide       ; Hide CMDB pane

        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  parm1 = Pointer to length-prefixed
                                    ; /            device/filename string

        
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.fb.fname.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        b    @edkey.action.top      ; Goto 1st line in editor buffer
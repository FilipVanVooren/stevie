* FILE......: edkey.fb.fíle.asm
* Purpose...: File related actions in frame buffer pane.

*---------------------------------------------------------------
* Load next or previous file based on last char in suffix
*---------------------------------------------------------------
* b   @edkey.action.fb.fname.inc.load
* b   @edkey.action.fb.fname.dec.load
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* none
********|*****|*********************|**************************
edkey.action.fb.fname.dec.load:
        mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
        clr   @parm2                ; Decrease ASCII value of char in suffix
        jmp   _edkey.action.fb.fname.doit

edkey.action.fb.fname.inc.load:
        mov   @fh.fname.ptr,@parm1  ; Set pointer to current filename
        seto  @parm2                ; Increase ASCII value of char in suffix                

_edkey.action.fb.fname.doit:
        ;------------------------------------------------------
        ; Sanity check        
        ;------------------------------------------------------
        mov   @parm1,tmp0
        jeq   _edkey.action.fb.fname.doit.exit
                                    ; Exit early if "New file"
        ;------------------------------------------------------
        ; Show dialog "Unsaved changed" if editor buffer dirty
        ;------------------------------------------------------
        mov   @edb.dirty,tmp0
        jeq   !
        b     @dialog.unsaved       ; Show dialog and exit
        ;------------------------------------------------------
        ; Update suffix and load file
        ;------------------------------------------------------
!       bl    @fm.browse.fname.suffix.incdec
                                    ; Filename suffix adjust
                                    ; i  \ parm1 = Pointer to filename
                                    ; i  / parm2 = >FFFF or >0000

        li    tmp0,heap.top         ; 1st line in heap
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           device/filename string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
_edkey.action.fb.fname.doit.exit:        
        b    @edkey.action.top      ; Goto 1st line in editor buffer 
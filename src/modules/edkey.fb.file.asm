* FILE......: edkey.fb.fíle.asm
* Purpose...: File related actions in frame buffer pane.


edkey.action.fb.buffer0:
        li   tmp0,fdname0
        jmp  _edkey.action.rest
edkey.action.fb.buffer1:
        li   tmp0,fdname1
        jmp  _edkey.action.rest
edkey.action.fb.buffer2:
        li   tmp0,fdname2
        jmp  _edkey.action.rest
edkey.action.fb.buffer3:
        li   tmp0,fdname3
        jmp  _edkey.action.rest
edkey.action.fb.buffer4:
        li   tmp0,fdname4
        jmp  _edkey.action.rest
edkey.action.fb.buffer5:
        li   tmp0,fdname5
        jmp  _edkey.action.rest
edkey.action.fb.buffer6:
        li   tmp0,fdname6
        jmp  _edkey.action.rest
edkey.action.fb.buffer7:
        li   tmp0,fdname7
        jmp  _edkey.action.rest
edkey.action.fb.buffer8:
        li   tmp0,fdname8
        jmp  _edkey.action.rest
edkey.action.fb.buffer9:
        li   tmp0,fdname9
        jmp  _edkey.action.rest
_edkey.action.rest:
        bl   @fm.loadfile           ; \ Load DIS/VAR 80 file into editor buffer 
                                    ; | i  tmp0 = Pointer to device and filename
                                    ; /

        b    @edkey.action.top      ; Goto 1st line in editor buffer 








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
edkey.action.fb.fname.inc.load:
        seto  @parm1                 ; Increase ASCII value of last char        
        bl   @fm.browse.fname.suffix.incdec
        jmp  _edkey.action.fb.fname.loadfile
edkey.action.fb.fname.dec.load:
        clr  @parm1                 ; Decrease ASCII value of last char
        bl   @fm.browse.fname.suffix.incdec
_edkey.action.fb.fname.loadfile:
        li    tmp0,heap.top         ; 1st line in heap
        bl    @fm.loadfile          ; Load DV80 file
                                    ; \ i  tmp0 = Pointer to length-prefixed
                                    ; /           device/filename string

        b    @edkey.action.top      ; Goto 1st line in editor buffer 
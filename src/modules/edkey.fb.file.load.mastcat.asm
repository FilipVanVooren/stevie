* FILE......: edkey.fb.file.predef.asm
* Purpose...: Load predefined file into editor

***************************************************************
* edkey.action.fb.load.mastcat
* Load master catalog into editor
***************************************************************
* b  @edkey.action.fb.load.mastcat
*--------------------------------------------------------------
* INPUT
* none
********|*****|*********************|**************************
edkey.action.fb.load.mastcat:
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        li    tmp0,def.mastcat
        mov   tmp0,@parm1
        ;-------------------------------------------------------
        ; About to load special file of type Master Catalog
        ;-------------------------------------------------------
        li    tmp0,id.special.mastcat
        mov   tmp0,@parm2
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        b     @edkey.action.fb.load.file

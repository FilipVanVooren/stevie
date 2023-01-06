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
        li    tmp0,def.mastercat
        mov   tmp0,@parm1
        b     @edkey.action.fb.load.file

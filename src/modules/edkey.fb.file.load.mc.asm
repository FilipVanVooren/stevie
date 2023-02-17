* FILE......: edkey.fb.file.load.mc.asm
* Purpose...: Load Master Catalog into editor

***************************************************************
* edkey.action.fb.load.mc
* Load master catalog into editor
***************************************************************
* b  @edkey.action.fb.load.mc
*--------------------------------------------------------------
* INPUT
* none
********|*****|*********************|**************************
edkey.action.fb.load.mc:
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        li    tmp0,tv.mc.fname
        mov   tmp0,@parm1
        ;-------------------------------------------------------
        ; Set special file type to 'Master Catalog'
        ;-------------------------------------------------------
        li    tmp0,id.special.mastcat
        mov   tmp0,@parm2
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        b     @edkey.action.fb.load.file
                                    ; \ Load file into editor
                                    ; | i  @parm1 = Pointer to filename string
                                    ; | i  @parm2 = Type of special file to load
                                    ; /

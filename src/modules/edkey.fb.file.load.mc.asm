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
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0   
        ;-------------------------------------------------------
        ; Set filename
        ;-------------------------------------------------------
        li    tmp0,tv.mc.fname
        mov   tmp0,@parm1
        ;-------------------------------------------------------
        ; Set special file type to 'Master Catalog'
        ;-------------------------------------------------------
        li    tmp0,id.special.mastcat
        mov   tmp0,@parm2           ; Set special file type
        ;-------------------------------------------------------
        ; Set special message
        ;-------------------------------------------------------
        li    tmp0,txt.msg.mastcat  ; \ Set pointer to special message 
        mov   tmp0,@tv.special.msg  ; / of Master Catalog        
        ;-------------------------------------------------------
        ; Load file
        ;-------------------------------------------------------
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
                
        b     @edkey.action.fb.load.file
                                    ; \ Load file into editor
                                    ; | i  @parm1 = Pointer to filename string
                                    ; | i  @parm2 = Type of special file to load
                                    ; /

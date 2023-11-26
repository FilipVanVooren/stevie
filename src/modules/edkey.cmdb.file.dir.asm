* FILE......: edkey.cmdb.fíle.directory.asm
* Purpose...: Drive/Directory listing

*---------------------------------------------------------------
* Drive/Directory presets
*---------------------------------------------------------------
edkey.action.cmdb.file.directory.1
        clr   @parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.2
        mov   @const.1,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.3
        mov   @const.2,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.4
        mov   @const.3,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.5
        mov   @const.4,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.6
        mov   @const.5,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.7
        mov   @const.6,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.8
        mov   @const.7,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.9
        mov   @const.8,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.a
        mov   @const.9,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.b
        mov   @const.10,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.c
        mov   @const.11,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.d
        mov   @const.12,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.e
        mov   @const.13,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.f
        mov   @const.14,@parm2

*---------------------------------------------------------------
* Drive/Directory listing
*---------------------------------------------------------------
edkey.action.cmdb.file.directory:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Catalog drive/directory
        ;-------------------------------------------------------
        clr   @parm1
        bl    @fm.directory
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.cmdb.file.catalog.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

        
edkey.action.filebrowser.1:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 1
        ;-------------------------------------------------------
        clr   @cat.page             ; Set page 1 (base 0)
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.1.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


edkey.action.filebrowser.2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 2
        ;-------------------------------------------------------
        li    tmp0,1                ; \ Set page 2 (base 0)
        mov   tmp0,@cat.page        ; /
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.2.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main


edkey.action.filebrowser.3:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;-------------------------------------------------------
        ; Show page 3
        ;-------------------------------------------------------
        li    tmp0,2                ; \ Set page 3 (base 0)
        mov   tmp0,@cat.page        ; /
        bl    @pane.filebrowser
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
edkey.action.filebrowser.3.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11        
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main                                    

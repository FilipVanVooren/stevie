* FILE......: edkey.cmdb.fíle.directory.asm
* Purpose...: Drive/Directory listing

*---------------------------------------------------------------
* Drive/Directory presets
*---------------------------------------------------------------
edkey.action.cmdb.file.directory.1:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        clr   @parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.2:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.1,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.3:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.2,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.4:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.3,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.5:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.4,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.6:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.5,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.7:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.6,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.8:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.7,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.9:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.8,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.a:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.9,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.b:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.10,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.c:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.11,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.d:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.12,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.e:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.13,@parm2
        jmp   edkey.action.cmdb.file.directory

edkey.action.cmdb.file.directory.f:
        clr   @parm1                ; Skip parameter 1. Will use @device.list
        mov   @const.14,@parm2
        jmp   edkey.action.cmdb.file.directory


edkey.action.cmdb.file.directory.device:
        bl    @cpym2m
              data cmdb.cmdall,cat.device,80
                                    ; Copy filename from command line to buffer
        li    tmp0,cat.device
        mov   tmp0,@parm1
        clr   @parm2
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
        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; /          (ignored if parm1 set)                                    
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

* FILE......: edkey.cmdb.updir.asm
* Purpose...: Go up one directory level

*---------------------------------------------------------------
* Go up one directory level
*---------------------------------------------------------------
* b   @edkey.action.cmdb.updir
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edkey.action.cmdb.updir:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Go up one directory level
        ;------------------------------------------------------
        bl    @fm.browse.updir      ; Go up one directory level
                                    ; \ i @cat.device = Current device name/path
                                    ; | o @outparm1   = >0000 if dir unchanged
                                    ; /                 >ffff if dir changed

        mov   @outparm1,tmp0        ; Get functional call result
        jeq   edkey.action.cmdb.updir.exit
        ;-------------------------------------------------------
        ; Catalog drive/directory
        ;-------------------------------------------------------
        li    tmp0,cat.device       ; \
        mov   tmp0,@parm1           ; / Set device name/path
        clr   @parm2

        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; /          (ignored if parm1 set)        
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.cmdb.updir.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

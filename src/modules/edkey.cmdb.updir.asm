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
                                    ; \ i @tv.devpath = Current device name/path
                                    ; | o @outparm1   = >0000 if dir unchanged
                                    ; /                 >ffff if dir changed

        mov   @outparm1,tmp0        ; Get functional call result
        jeq   edkey.action.cmdb.updir.exit
        ;-------------------------------------------------------
        ; Catalog drive/directory
        ;-------------------------------------------------------
        li    tmp0,tv.devpath       ; \
        mov   tmp0,@parm1           ; / Set device name/path
        clr   @parm2

        clr   @parm3                ; Show filebrowser after reading directory
        bl    @fm.directory         ; Read device directory
                                    ; \ @parm1 = Pointer to length-prefixed 
                                    ; |          string containing device
                                    ; |          or >0000 if using parm2
                                    ; | @parm2 = Index in device list
                                    ; |          (ignored if parm1 set)
                                    ; / @parm3 = Skip filebrowser flag

        ;-------------------------------------------------------
        ; Update command line with device path if catalog dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.cat    ;
        c     @cmdb.dialog,tmp0     ; Is catalog dialog active?
        jne   edkey.action.cmdb.updir.exit
                                    ; No, exit

        bl    @cpym2m
              data tv.devpath,cmdb.cmdall,80
                                    ; Copy device path to command line

        seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)        
        ;-------------------------------------------------------
        ; Cursor end of line
        ;-------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length byte of current command
        srl   tmp0,8                ; Right justify
        mov   tmp0,@cmdb.column     ; Save column position
        inc   tmp0                  ; One time adjustment command prompt        
        swpb  tmp0                  ; LSB TO MSB
        movb  tmp0,@cmdb.cursor+1   ; Set cursor position        
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.cmdb.updir.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

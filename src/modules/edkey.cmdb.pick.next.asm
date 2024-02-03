* FILE......: edkey.cmdb.file.next.asm
* Purpose...: File selection actions in CMDB pane

*---------------------------------------------------------------
* Pick next file from catalog
*---------------------------------------------------------------
* b   @edkey.action.cmdb.pick.next
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edkey.action.cmdb.pick.next:
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        bl    @fm.browse.fname.next ; Next file in catalog filename list
        mov   @outparm1,tmp0        ; Skipped flag set?
        jne   edkey.action.cmdb.pick.next.exit
                                    ; Yes, exit early

        bl    @pane.filebrowser.hilight                                                                        
        ;------------------------------------------------------
        ; Next file
        ;------------------------------------------------------
edkey.action.cmdb.pick.next.setfile:        
        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy filename from command line to buffer
        ;---------------------------------------------------------------
        ; Cursor end of line
        ;---------------------------------------------------------------
        movb  @cmdb.cmdlen,tmp0     ; Get length byte of current command
        srl   tmp0,8                ; Right justify
        mov   tmp0,@cmdb.column     ; Save column position
        inc   tmp0                  ; One time adjustment command prompt        
        swpb  tmp0                  ; LSB TO MSB
        movb  tmp0,@cmdb.cursor+1   ; Set cursor position        

        seto  @cmdb.dirty           ; Set CMDB dirty flag (trigger redraw)        
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.cmdb.pick.next.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

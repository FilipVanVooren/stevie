* FILE......: edk.cmdb.pick.next.asm
* Purpose...: File selection actions in CMDB pane

*---------------------------------------------------------------
* Pick next file from catalog
*---------------------------------------------------------------
* b   @edk.act.cmdb.pick.next
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edk.act.cmdb.pick.next:
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        bl    @fm.browse.fname.next ; Next file in catalog filename list
        abs   @outparm1             ; Skipped flag set?
        jne   edk.act.cmdb.pick.next.exit
                                    ; Yes, exit early

        bl    @pane.filebrowser.hilight                                                                        
        ;------------------------------------------------------
        ; Next file
        ;------------------------------------------------------
edk.act.cmdb.pick.next.setfile:        
        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy full filename to command line
                                    
        bl    @cmdb.refresh_prompt  ; Refresh command line
        bl    @cmdb.cmd.cursor_eol  ; Cursor at end of input
        bl    @vdp.cursor.tat       ; Update cursor
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edk.act.cmdb.pick.next.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

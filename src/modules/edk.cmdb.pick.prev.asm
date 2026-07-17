* FILE......: edk.cmdb.pick.prev.asm
* Purpose...: File selection actions in CMDB pane

*---------------------------------------------------------------
* Pick previous file from catalog
*---------------------------------------------------------------
* b   @edk.act.cmdb.pick.prev
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edk.act.cmdb.pick.prev:
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        bl    @fm.browse.fname.prev ; Previous file in catalog filename list

        abs   @outparm1             ; Skipped flag set?
        jne   edk.act.cmdb.pick.prev.exit
                                    ; Yes, exit early

        bl    @pane.filebrowser.hilight                                    
        ;------------------------------------------------------
        ; Previous file
        ;------------------------------------------------------
edk.act.cmdb.pick.prev.setfile:
        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy full filename to command line

        bl    @cmdb.refresh_prompt  ; Refresh command line
        bl    @cmdb.cmd.cursor_eol  ; Cursor at end of input
        bl    @vdp.cursor.tat       ; Update cursor
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edk.act.cmdb.pick.prev.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

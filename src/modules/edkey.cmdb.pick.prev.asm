* FILE......: edkey.cmdb.file.prev.asm
* Purpose...: File selection actions in CMDB pane

*---------------------------------------------------------------
* Pick previous file from catalog
*---------------------------------------------------------------
* b   @edkey.action.cmdb.pick.prev
*--------------------------------------------------------------- 
* INPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
edkey.action.cmdb.pick.prev:
        ;------------------------------------------------------
        ; Adjust filename
        ;------------------------------------------------------
        bl    @fm.browse.fname.prev ; Previous file in catalog filename list

        abs   @outparm1             ; Skipped flag set?
        jne   edkey.action.cmdb.pick.prev.exit
                                    ; Yes, exit early

        bl    @pane.filebrowser.hilight                                    
        ;------------------------------------------------------
        ; Previous file
        ;------------------------------------------------------
edkey.action.cmdb.pick.prev.setfile:
        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy full filename to command line

        bl    @cmdb.refresh_prompt  ; Refresh command line
        bl    @cmdb.cmd.cursor_eol  ; Cursor at end of input
        bl    @vdp.cursor.tat       ; Update cursor
        ;------------------------------------------------------        
        ; Exit
        ;------------------------------------------------------
edkey.action.cmdb.pick.prev.exit:
        b     @edkey.keyscan.hook.debounce
                                    ; Back to editor main

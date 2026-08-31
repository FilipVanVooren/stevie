* FILE......: dialog.main.asm
* Purpose...: Dialog "Main Menu"

***************************************************************
* dialog.main
* Open Dialog "Main Menu"
***************************************************************
* bl @dialog.main
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.main:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000) 
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.main
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.menu
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        mov   @edb.locked,tmp0      ; Is editor locked?
        jeq   !                     ; no, hide "Unlock" option in menu
        ;-------------------------------------------------------
        ; Menu with "Unlock" option
        ;-------------------------------------------------------
        li    tmp0,txt.info.menulock
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menulock
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        jmp   dialog.main.statlines 
        ;-------------------------------------------------------
        ; Menu without "Unlock" option
        ;-------------------------------------------------------
!       li    tmp0,txt.info.menu
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menu
        mov   tmp0,@cmdb.panmarkers ; Show letter markers        
        ;-------------------------------------------------------
        ; Show Status lines
        ;-------------------------------------------------------
dialog.main.statlines:
        bl    @pane.cmdb.statlines  ; Show status lines
                                    ; i \   @tv.devpath = Pointer to device path 
                                    ; i |   @tv.sams.maxpage = SAMS pages in system
                                    ; i |   @tv.sams.hipage = Highest page in use
                                    ; o |   @ram.msg1 = SAMS free status line
                                    ; o /   @ram.msg2 = Device path status line
        ;------------------------------------------------------
        ; Remove filepicker color bar
        ;------------------------------------------------------
        bl    @pane.filebrowser.colbar.remove
                                    ; Remove filepicker color bar
                                    ; i \  @cat.barpos = YX position color bar
                                    ;   / 

        li    tmp0,col.keys.menu
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.main.exit:
        .popregs 0                  ; Pop registers and return to caller

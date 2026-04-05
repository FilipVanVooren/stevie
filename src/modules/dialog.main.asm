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
        .pushregs 4                 ; Push registers and return address on stack
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
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.main.exit:
        .popregs 4                  ; Pop registers and return to caller

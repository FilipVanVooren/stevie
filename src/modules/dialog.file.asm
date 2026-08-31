* FILE......: dialog.file.asm
* Purpose...: Dialog "File"

***************************************************************
* dialog.file
* Open Dialog "File"
***************************************************************
* bl @dialog.file
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.file:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.file
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.file
        mov   tmp0,@cmdb.panhead    ; Header for dialog
        ;-------------------------------------------------------
        ; Editor buffer locked?
        ;-------------------------------------------------------
        mov   @edb.locked,tmp0      ; Is editor locked?
        jeq   !                     ; No, show all options
        ;-------------------------------------------------------
        ; Reduced options
        ;-------------------------------------------------------
        li    tmp0,txt.info.filelock
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.filelock
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        jmp   dialog.file.statlines
        ;-------------------------------------------------------
        ; All options
        ;-------------------------------------------------------
!       li    tmp0,txt.info.file
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.file
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        ;-------------------------------------------------------
        ; Show Status lines
        ;-------------------------------------------------------
dialog.file.statlines:
        bl    @pane.cmdb.statlines  ; Show status lines
                                    ; i \   @tv.devpath = Pointer to device path 
                                    ; i |   @tv.sams.maxpage = SAMS pages in system
                                    ; i |   @tv.sams.hipage = Highest page in use
                                    ; o |   @ram.msg1 = SAMS free status line
                                    ; o /   @ram.msg2 = Device path status line

        li    tmp0,txt.keys.file    ; No navigation keys
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.file
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers

        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)                
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.file.exit:
        .popregs 0                  ; Pop registers and return to caller

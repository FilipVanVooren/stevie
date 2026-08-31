* FILE......: dialog.find.asm
* Purpose...: Dialog "Find"

***************************************************************
* dialog.find
* Dialog "Find"
***************************************************************
* bl @dialog.find
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
*--------------------------------------------------------------
* Notes
********|*****|*********************|**************************
dialog.find:
        .pushregs 2                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------        
        li    tmp0,id.dialog.find
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.find
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        clr   @cmdb.paninfo         ; No info message
        clr   @cmdb.panmarkers      ; No letter markers
        clr   @cmdb.panhint2        ; No extra hint to display

        li    tmp0,txt.hint.find
        mov   tmp0,@cmdb.panhint    ; Show 'Enter search string.'

        li    tmp0,txt.hint.find2
        mov   tmp0,@cmdb.panhint2   ; Show toggle

        li    tmp0,txt.keys.find
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.find
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers              

        bl    @cpym2m
              data edb.srch.str,cmdb.cmdall,80
                                    ; Set input value to search string

        bl    @pane.cursor.blink    ; Show cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)        
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.find.exit:
        .popregs 2                  ; Pop registers and return to caller

* basic......: dialog.cart.type.asm
* Purpose....: Dialog "Cart"

***************************************************************
* dialog.cart.type
* Open Dialog "Cart"
***************************************************************
* bl @dialog.cart.type
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
dialog.cart.type:
        .pushregs 0                 ; Push return address and registers on stack
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.cart.type
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        li    tmp0,txt.head.cart.type
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.info.cart.type
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.cart.type
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,txt.hint.cart.type2
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display

        clr   @cmdb.panhint         ; No hint in bottom line

        li    tmp0,txt.keys.cart.type
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.cart.type
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers

        bl    @pane.cursor.hide     ; Hide cursor
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)             
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.cart.type.exit:
        .popregs 0                  ; Pop registers and return to caller
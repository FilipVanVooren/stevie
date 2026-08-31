* FILE......: dialog.help.asm
* Purpose...: Dialog "Help"

*---------------------------------------------------------------
* Show Stevie help dialog
*---------------------------------------------------------------
dialog.help:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Set SAMS pages that has dialogs data
        ;-------------------------------------------------------        
        bl    @mem.sams.dialogs.on  ; Turn on SAMS pages #2 (>b000) and #3 (>c000)         
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.help
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        bl    @dialog.help.content  ; display content in modal dialog

        li    tmp0,txt.head.about
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.about.build
        mov   tmp0,@cmdb.paninfo    ; Info line
        clr   @cmdb.panmarkers      ; No key markers

        li    tmp0,txt.hint.about
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line
        li    tmp0,txt.hint.about2
        mov   tmp0,@cmdb.panhint2   ; Extra hint to display

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        li    tmp0,col.keys.about
        mov   tmp0,@cmdb.keycolors  ; Color position for key markers
        ;------------------------------------------------------
        ; Restore current SAMS pages
        ;------------------------------------------------------
        bl    @mem.sams.dialogs.off ; Turn off SAMS pages #2 (>b000) and #3 (>c000)                      
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.help.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return

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
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
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
        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.file.exit:
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

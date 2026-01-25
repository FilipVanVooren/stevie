* FILE......: dialog.menu.asm
* Purpose...: Dialog "Main Menu"

***************************************************************
* dialog.menu
* Open Dialog "Main Menu"
***************************************************************
* bl @dialog.menu
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
dialog.menu:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.menu
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
        jmp   dialog.menu.statlines 
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
dialog.menu.statlines:
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
dialog.menu.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

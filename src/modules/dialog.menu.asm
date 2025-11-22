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
        jeq   !                     ; yes, no "Unlock" option in menu
        ;-------------------------------------------------------
        ; Menu with "Unlock" option
        ;-------------------------------------------------------
        li    tmp0,txt.info.menulock
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menulock
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        jmp   dialog.menu.sams
        ;-------------------------------------------------------
        ; Menu without "Unlock" option
        ;-------------------------------------------------------
!       li    tmp0,txt.info.menu
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menu
        mov   tmp0,@cmdb.panmarkers ; Show letter markers
        ;-------------------------------------------------------
        ; Show Status line (SAMS free, ...)
        ;-------------------------------------------------------
dialog.menu.sams:
        bl    @film
              data ram.msg1,0,160   ; Clear both status lines

        li    tmp0,>4c00            ; MSB = 76
        movb  tmp0,@ram.msg1        ; Set line 1 length 
        movb  tmp0,@ram.msg2        ; Set line 2 length 

        li    tmp0,ram.msg1
        mov   tmp0,@cmdb.panhint    ; Show status line 1
        li    tmp0,ram.msg2
        mov   tmp0,@cmdb.panhint2   ; Show status line 2

        li    tmp0,txt.keys.menu
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor

        dect  stack
        mov   @wyx,*stack           ; Save cursor position

        bl    @hchar
              byte 0,0,32,80
              data eol              ; Remove leftover junk from previous dialog

        mov   *stack+,@wyx          ; Restore cursor position
        ;-------------------------------------------------------
        ; Print SAMS pages free
        ;-------------------------------------------------------
        li    tmp0,tv.sams.maxpage  ; Calculate number of free pages
        s     @edb.sams.hipage,tmp0 ;

        mov   tmp0,@rambuf          ; Number of pages free

        bl    @cpym2m
              data txt.hint.sams+1,ram.msg1+1,14

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data rambuf           ; \ i  p1    = Source
              data rambuf+2         ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf+2,ram.msg1+6,32

        li    tmp0,>2000            ; \ MSB = ASCII 32 (hex 20) space char
        movb  tmp0,@ram.msg1 + 6    ; | Overwrite length-byte prefix in 
                                    ; / number with colon
        ;-------------------------------------------------------
        ; Show path
        ;-------------------------------------------------------
        movb  @cat.device,tmp0      ; Path set?
        srl   tmp0,8                ; Check length byte
        jeq   !                     ; Nothing set, skip

        bl    @cpym2m
              data txt.hint.path+1,ram.msg2+1,5

        bl    @cpym2m
              data cat.device,ram.msg2+6,60

        li    tmp0,>2000
        movb  tmp0,@ram.msg2+6                  
        ;------------------------------------------------------
        ; Remove filepicker color bar
        ;------------------------------------------------------
!       bl    @pane.filebrowser.colbar.remove
                                    ; Remove filepicker color bar
                                    ; i \  @cat.barpos = YX position color bar
                                    ;   /                                                             
        ;-------------------------------------------------------
        ; Exit
        ;-------------------------------------------------------
dialog.menu.exit:
        mov   *stack+,tmp0          ; Pop tmp4
        mov   *stack+,tmp0          ; Pop tmp3
        mov   *stack+,tmp0          ; Pop tmp2
        mov   *stack+,tmp0          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

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

        li    tmp0,txt.info.menu
        mov   tmp0,@cmdb.paninfo    ; Info message instead of input prompt

        li    tmp0,pos.info.menu
        mov   tmp0,@cmdb.panmarkers ; Show letter markers

        li    tmp0,ram.msg1
        mov   tmp0,@cmdb.panhint    ; Show SAMS memory allocation
        
        clr    @cmdb.panhint2       ; No extra hint to display

        li    tmp0,txt.keys.menu
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @pane.cursor.hide     ; Hide cursor
        ;-------------------------------------------------------
        ; Print SAMS pages free
        ;-------------------------------------------------------
        li    tmp0,tv.sams.maxpage  ; Calculate number of free pages
        s     @edb.sams.hipage,tmp0 ;

        mov   tmp0,@rambuf          ; Number of ages free

        clr   @ram.msg1 + 18        ; \ Remove any previous number
        clr   @ram.msg1 + 20        ; /

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data rambuf           ; \ i  p1    = Source
              data rambuf+2         ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data  rambuf+2,ram.msg1 + 18,32

        movb  @const.0,@ram.msg1 + 18
                                    ; \ Overwrite length-byte prefix in 
                                    ; / trimmed number
        ;-------------------------------------------------------
        ; Print SAMS pages total
        ;-------------------------------------------------------
        li    tmp0,tv.sams.maxpage  ; Max number of SAMS pages supported
        mov   tmp0,@rambuf          ; Number of pages free

        clr   @ram.msg1 + 44        ; \ Remove any previous number
        clr   @ram.msg1 + 46        ; /

        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data rambuf           ; \ i  p1    = Source
              data rambuf+2         ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data  rambuf+2,ram.msg1 + 44,32

        movb  @const.0,@ram.msg1 + 44
                                    ; \ Overwrite length-byte prefix in 
                                    ; / trimmed number
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

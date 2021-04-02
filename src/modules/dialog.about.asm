* FILE......: dialog.about.asm
* Purpose...: Stevie Editor - About dialog

*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
dialog.about:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        li    tmp0,id.dialog.about
        mov   tmp0,@cmdb.dialog     ; Set dialog ID

        bl    @dialog.about.content ; display content in modal dialog

        li    tmp0,txt.head.about
        mov   tmp0,@cmdb.panhead    ; Header for dialog

        li    tmp0,txt.about.build
        mov   tmp0,@cmdb.paninfo    ; Info line

        li    tmp0,txt.hint.about
        mov   tmp0,@cmdb.panhint    ; Hint in bottom line

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.about.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
               


***************************************************************
* dialog.about.content
* Show content in modal dialog
***************************************************************
* bl  @dialog.about.content
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
dialog.about.content:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Show About dialog
        ;------------------------------------------------------
        bl    @hchar
              byte 0,0,32,50      
              data eol              ; Clear filename

        bl    @putat      
              byte   0,0
              data   txt.stevie

        bl    @cpym2v
              data  80,dialog.about.help,24*80 
                                    ; Dump key shortcuts to VDP
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.about.content.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return



dialog.about.help:
        text 'Movement keys:                           |   Modifier keys:                     '
        text '   Fctn S        Cursor left             |      Fctn 1        Delete character  '
        text '   Fctn D        Cursor right            |      Fctn 2        Insert character  '
        text '   Fctn E        Cursor up               |      Fctn 3        Delete line       '
        text '   Fctn X        Cursor down             |      Fctn 4        Delete end of line'
        text '   Fctn H        Cursor home             |      Fctn 5        Insert line       '
        text '   Fctn J        Cursor to prev. word    |      Fctn .        Insert/Overwrite  '
        text '   Fctn K        Cursor to next word     |                                      '
        text '   Fctn L        Cursor to end           |                                      '
        text '   Ctrl E  (^e)  Page up                 |                                      '
        text '   Ctrl X  (^x)  Page down               |                                      '
        text '   Ctrl B  (^b)  End of file             |                                      '
        text '   Ctrl T  (^t)  Top of file             |                                      '
        text '                                         |                                      '
        text 'Action keys:                             |   Block operations:                  '
        text '   Fctn 0         Help                   |      Ctrl d (^d)   Delete block      '
        text '   Fctn +         Quit editor            |      Ctrl c (^c)   Copy block        '
        text '   Ctrl o (^o)    Open file              |      Ctrl g (^g)   Goto marker M1    '
        text '   Ctrl s (^s)    Save file              |      Ctrl m (^m)   Move block        '
        text '   Ctrl v (^v)    Set M1/M2 marker       |      Ctrl s (^s)   Save block to file'
        text '   Ctrl r (^r)    Reset M1/M2 markers    |                                      '
        text '   Ctrl z (^z)    Cycle color schemes    |                                      '
        text '   Ctrl , (^,)    Load previous file     |                                      '
        text '   Ctrl . (^.)    Load next file         |                                      '

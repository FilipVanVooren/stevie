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
        bl    @scroff               ; turn screen off

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

        bl    @scron                ; Turn screen on
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
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
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
              data   txt.stevie     ; Show Stevie version

        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size.80x30 - 160
                                    ; Clear screen
        
        bl    @filv
              data sprsat,0,32      ; Turn off sprites

        ;------------------------------------------------------
        ; Display keyboard shortcuts (part 1)
        ;------------------------------------------------------
        li    tmp0,>0200            ; Y=2, X=0
        mov   tmp0,@wyx             ; Set cursor position
        li    tmp1,dialog.about.help.part1
                                    ; Pointer to string
        li    tmp2,21               ; Set loop counter

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

        ;------------------------------------------------------
        ; Display keyboard shortcuts (part 2)
        ;------------------------------------------------------
        li    tmp0,>032c            ; Y=3, X=44
        mov   tmp0,@wyx             ; Set cursor position
        li    tmp1,dialog.about.help.part2
                                    ; Pointer to string
        li    tmp2,19               ; Set loop counter

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.about.content.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0               
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return



dialog.about.help.part1:
        #string 'Movement keys:'
        #string '   Fctn S        Cursor left'
        #string '   Fctn D        Cursor right'
        #string '   Fctn E        Cursor up'
        #string '   Fctn X        Cursor down'
        #string '   Fctn H        Cursor home'
        #string '   Fctn J        Cursor to prev. word'
        #string '   Fctn K        Cursor to next word'
        #string '   Fctn L        Cursor to end'
        #string '   Ctrl E  (^e)  Page up'
        #string '   Ctrl X  (^x)  Page down'
        #string '   Ctrl T  (^t)  File top'
        #string '   Ctrl B  (^b)  File bottom'
        #string ' '
        #string 'Action keys:'
        #string '   Fctn +         Quit'
        #string '   Ctrl h (^h)    Help'
        #string '   Ctrl o (^o)    Open file'
        #string '   Ctrl s (^s)    Save file'
        #string '   Ctrl v (^v)    Set M1/M2 marker'
        #string '   Ctrl r (^r)    Reset M1/M2 markers'
        #string '   Ctrl z (^z)    Cycle color schemes'
        
dialog.about.help.part2:
        #string '   Ctrl , (^,)    Load previous file'
        #string '   Ctrl . (^.)    Load next file'
        #string '   ctrl u (^u)    Toggle ruler'
        #string ' '
        #string 'Block operations:'
        #string '   Ctrl d (^d)   Delete block'
        #string '   Ctrl c (^c)   Copy block'
        #string '   Ctrl g (^g)   Goto marker M1'
        #string '   Ctrl m (^m)   Move block'
        #string '   Ctrl s (^s)   Save block to file'
        #string ' '
        #string 'Modifier keys:'
        #string '   Fctn 1   Delete character'
        #string '   Fctn 2   Insert character'
        #string '   Fctn 3   Delete line'
        #string '   Fctn 4   Delete end of line'
        #string '   Fctn 5   Insert line'
        #string '   Fctn 7   Move to next tab'
        #string '   Fctn .   Toggle Insert/Overwrite'


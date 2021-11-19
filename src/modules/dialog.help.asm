* FILE......: dialog.help.asm
* Purpose...: Stevie Editor - About dialog

*---------------------------------------------------------------
* Show Stevie welcome/about dialog
*---------------------------------------------------------------
dialog.help:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;-------------------------------------------------------
        ; Setup dialog
        ;-------------------------------------------------------
        bl    @scroff               ; turn screen off

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

        li    tmp0,txt.keys.about
        mov   tmp0,@cmdb.pankeys    ; Keylist in status line

        bl    @scron                ; Turn screen on
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.help.exit:
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return
               


***************************************************************
* dialog.help.content
* Show content in modal dialog
***************************************************************
* bl  @dialog.help.content
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
dialog.help.content:
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
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 160
                                    ; Clear screen
        
        bl    @filv
              data sprsat,0,32      ; Turn off sprites

        ;------------------------------------------------------
        ; Display keyboard shortcuts (part 1)
        ;------------------------------------------------------
        li    tmp0,>0100            ; Y=1, X=0
        mov   tmp0,@wyx             ; Set cursor position
        li    tmp1,dialog.help.help.part1
                                    ; Pointer to string
        li    tmp2,23               ; Set loop counter

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

        ;------------------------------------------------------
        ; Display keyboard shortcuts (part 2)
        ;------------------------------------------------------
        li    tmp0,>012a            ; Y=1, X=42
        mov   tmp0,@wyx             ; Set cursor position
        li    tmp1,dialog.help.help.part2
                                    ; Pointer to string
        li    tmp2,24               ; Set loop counter

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.help.content.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0               
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return



dialog.help.help.part1:
        #string '------------- Cursor --------------'
        #string 'Fctn s        Left'
        #string 'Fctn d        Right'
        #string 'Fctn e        Up'
        #string 'Fctn x        Down'
        #string 'Fctn h        Home'
        #string 'Fctn l        End'
        #string 'Fctn j        Prev word'
        #string 'Fctn k        Next word'
        #string 'Fctn 7   ^t   Next tab'
        #string 'Fctn 6   ^e   Page up'
        #string 'Fctn 4   ^x   Page down'
        #string 'Fctn v        Screen top'
        #string 'Fctn b        Screen bottom'
        #string 'Ctrl v   ^v   File top'
        #string 'Ctrl b   ^b   File bottom'

        #string ' '
        #string '------------- Others --------------'
        #string 'Fctn +   ^q   Quit'
        #string 'Ctrl h   ^h   Help'
        #string 'ctrl u   ^u   Toggle ruler'
        #string 'Ctrl z   ^z   Cycle color schemes'
        #string 'ctrl /   ^/   TI Basic (F9=exit)'

dialog.help.help.part2:
        #string '------------- File ----------------'
        #string 'Ctrl i   ^i   Insert file at cursor'
        #string 'Ctrl c   ^c   Insert clipboard 1-5'
        #string 'Ctrl o   ^o   Open file'
        #string 'Ctrl p   ^p   Print file'
        #string 'Ctrl s   ^s   Save file'
        #string 'Ctrl ,   ^,   Load prev file'
        #string 'Ctrl .   ^.   Load next file'
        #string '------------- Block mode ----------'
        #string 'Ctrl SPACE    Set M1/M2 marker'
        #string 'Ctrl d   ^d   Delete block'
        #string 'Ctrl c   ^c   Copy block'
        #string 'Ctrl g   ^g   Goto marker M1'
        #string 'Ctrl m   ^m   Move block'
        #string 'Ctrl s   ^s   Save block to file'
        #string 'Ctrl ^1..^5   Save to clipboard 1-5'
        #string ' '
        #string '------------- Modifiers -----------'
        #string 'Fctn 1        Delete character'
        #string 'Fctn 2        Insert character'
        #string 'Fctn 3        Delete line'
        #string 'Ctrl l   ^l   Delete end of line'
        #string 'Fctn 8        Insert line'
        #string 'Fctn .        Insert/Overwrite'
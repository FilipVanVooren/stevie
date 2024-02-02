* FILE......: dialog.help.content.asm
* Purpose...: Content for Help dialog


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
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   @wyx,*stack           ; Push cursor position
        ;------------------------------------------------------
        ; Clear screen and set colors
        ;------------------------------------------------------
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 640
                                    ; Clear screen

        ;
        ; Colours are also set in pane.colorscheme.load
        ; but we also set them here to avoid flickering due to
        ; timing delay before function is called.
        ;

        li    tmp0,vdp.fb.toprow.tat
        mov   @tv.color,tmp1        ; Get color for framebuffer
        srl   tmp1,8                ; Right justify
        li    tmp2,vdp.sit.size - 640
                                    ; Prepare for loading color attributes

        bl    @xfilv                ; \ Fill VDP memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill

        bl    @filv
              data sprsat,>d0,32    ; Turn off sprites
        ;------------------------------------------------------
        ; Display left column
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 1,0              ; Y=1, X=0

        mov   @cmdb.dialog.var,tmp3 ; Get Page index

        clr   tmp0                  ; Single-column list

        mov   @dialog.help.data.pages(tmp3),tmp1
                                    ; Pointer to list of strings
        mov   @dialog.help.data.pages+2(tmp3),tmp2
                                    ; Number of strings to display

        clr   tmp3                  ; No string padding                                    

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp0 = Cutover row and column offset
                                    ; |           for next column, >0000 for
                                    ; |           single column list
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; | i  tmp2 = Number of strings to display
                                    ; | i  tmp3 = String padding length
                                    ; |
                                    ; | o  @waux1 = Pointer to next entry  
                                    ; |             in list after displaying
                                    ; /             (tmp2) entries                                    
                                    
        ;------------------------------------------------------
        ; Display right column
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 0,42             ; Y=0, X=42

        mov   @cmdb.dialog.var,tmp3 ; Get Page index

        clr   tmp0                  ; Single-column list

        mov   @dialog.help.data.pages+4(tmp3),tmp1
                                    ; Pointer to list of strings
        mov   @dialog.help.data.pages+6(tmp3),tmp2
                                    ; Number of strings to display

        clr   tmp3                  ; No string padding

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp0 = Cutover row and column offset
                                    ; |           for next column, >0000 for
                                    ; |           single column list
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; | i  tmp2 = Number of strings to display
                                    ; | i  tmp3 = String padding length
                                    ; |
                                    ; | o  @waux1 = Pointer to next entry  
                                    ; |             in list after displaying
                                    ; /             (tmp2) entries                                    

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
dialog.help.content.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop r11
        b     *r11                  ; Return



dialog.help.data.pages:
        data  dialog.help.data.page1.left,14
        data  dialog.help.data.page1.right,18
        data  dialog.help.data.page2.left,16
        data  dialog.help.data.page2.right,10


dialog.help.data.page1.left:
        stri ' '
        byte    38
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Cursor '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn s/d/e/x  Left, Right, Up, Down'
        stri 'Fctn h/l      Home, End of line'
        stri 'Fctn j/k      Previous word, Next word'
        stri 'Fctn 4   ^x   Page down'
        stri 'Fctn 6   ^e   Page up'
        stri 'Ctrl 7   ^7   Prev tab'        
        stri 'Fctn 7        Next tab'
        stri 'Fctn v        Screen top'
        stri 'Fctn b        Screen bottom'
        stri 'Ctrl v   ^v   File top'
        stri 'Ctrl b   ^b   File bottom'
        stri 'Ctrl g   ^g   Goto line'


dialog.help.data.page1.right:
        stri '                                   1/2'
        stri ' '
        byte    36
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' File '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Ctrl a   ^a   Append file'
        stri 'Ctrl i   ^i   Insert file at line'
        stri 'Ctrl c   ^c   Copy clipboard to line'
        stri 'Ctrl o   ^o   Open file'
        stri 'Ctrl p   ^p   Print file'
        stri 'Ctrl s   ^s   Save file'
        stri 'Ctrl ,   ^,   Load prev file (catalog)'
        stri 'Ctrl .   ^.   Load next file (catalog)'
        byte    35
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Others '
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn +   ^q   Quit'
        stri 'Fctn 0   ^/   TI Basic'
        stri 'Ctrl h   ^h   Help'
        stri 'Ctrl r   ^r   Toggle ruler'
        stri 'Ctrl u   ^u   Shortcuts menu'
        stri 'Ctrl z   ^z   Cycle color schemes'

dialog.help.data.page2.left:
        stri ' '
        byte    35
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Modifiers '
        byte    1,1,1,1,1,1,1,1,1,1,1
        stri 'Fctn 1        Delete character'
        stri 'Fctn 2        Insert character'
        stri 'Fctn 3        Delete line'
        stri 'Ctrl l   ^l   Delete end of line'
        stri 'Fctn 8        Insert line'
        stri 'Fctn .        Insert/Overwrite'
        stri ' '
        byte    35
        byte    1,1,1,1,1,1
        text    ' File picker (catalog) '
        byte    1,1,1,1,1,1
        stri 'Ctrl e   ^e   Previous page'
        stri 'Ctrl x   ^x   Next page'
        stri 'Ctrl s   ^s   Previous column'
        stri 'Ctrl d   ^d   Next column'
        stri 'Fctn e/x      Up/Down'
        stri 'Ctrl 0-9 ^0-9 Catalog DSK1-DSK9'

dialog.help.data.page2.right:
        stri '                                   2/2'
        stri ' '
        byte    36
        byte    1,1,1,1,1,1,1,1,1,1,1,1,1
        text    ' Block Mode '
        byte    1,1,1,1,1,1,1,1,1,1,1
        stri 'Ctrl SPACE    Set M1/M2 marker'
        stri 'Ctrl d   ^d   Delete block'
        stri 'Ctrl c   ^c   Copy block'
        stri 'Ctrl g   ^g   Goto line'
        stri 'Ctrl m   ^m   Move block'
        stri 'Ctrl s   ^s   Save block to file'
        stri 'Ctrl ^1..^3   Copy to clipboard 1-3'

* FILE......: dialog.help.content.asm
* Purpose...: Content for Help dialog

***************************************************************
* dialog.help.content
* Show content in modal dialog
***************************************************************
* bl  @dialog.help.content
*--------------------------------------------------------------
* INPUT
* @cmdb.dialog.var = Page index (0-based)
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
        ; Reset index if necessary
        ;------------------------------------------------------
        c     @cmdb.dialog.var,@dialog.help.maxpage
        jgt   !
        jmp   dialog.help.content.clear
!       clr   @cmdb.dialog.var      ; Reset to page 0 if index is out of bounds
        ;------------------------------------------------------
        ; Clear screen and set colors
        ;------------------------------------------------------
dialog.help.content.clear:        
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - (cmdb.rows * 80) - 180
                                    ; Clear screen

        bl    @hchar
              byte pane.botrow - 4,2,32,76
              data EOL              ; Fill with space characters

        bl    @putnum               ; Show page number
              byte 0,70             ; \ i p1 = Y,X
              data cmdb.dialog.var  ; | i p2 = Number to display
              data rambuf           ; | i p3 = Workbuffer for string conversion
              data >3120            ; / i p4 = ASCII offset + 1, fill character

        bl    @putat
              byte 0,75
              data txt.dialog.help.maxpage
        
        ;
        ; Colours are also set in pane.colorscheme.load
        ; but we also set them here to avoid flickering due to
        ; timing delay before function is called.
        ;

        li    tmp0,vdp.fb.toprow.tat + 80
        mov   @tv.color,tmp1        ; Get color for framebuffer
        srl   tmp1,8                ; Right justify
        li    tmp2,vdp.sit.size - (cmdb.rows * 80) - 240          
                                    ; Prepare for loading color attributes

        bl    @xfilv                ; \ Fill VDP memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        ;------------------------------------------------------
        ; Display help screen
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 2,0              ; Y=2, X=0

        mov   @cmdb.dialog.var,tmp3 ; Get Page index
        sla   tmp3,3                ; Multiply by 8 to get offset in pages array

        mov   @dialog.help.data.pages+6(tmp3),tmp0
                                    ; Cutover row and column offset next column

        mov   @dialog.help.data.pages(tmp3),tmp1
                                    ; Pointer to list of strings

        mov   @dialog.help.data.pages+2(tmp3),tmp2
                                    ; Number of strings to display

        mov   @dialog.help.data.pages+4(tmp3),tmp3
                                    ; String padding length

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
        .popregs 3                  ; Pop registers and return to caller        

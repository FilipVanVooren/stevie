* FILE......: pane.filebrowser.asm
* Purpose...: File browser in dialog pane

*---------------------------------------------------------------
* File browser
*---------------------------------------------------------------
* bl   @pane.filebrowser
*--------------------------------------------------------------- 
* INPUT
* @cat.fpicker.idx = 1st file to show in file browser
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.filebrowser:
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
        ; Initialisation
        ;------------------------------------------------------
        bl    @filv
              data vdp.sit.base,32,vdp.sit.size - 560
                                    ; Clear screen (up to CMDB)

        ;------------------------------------------------------
        ; Load colorscheme and turn on screen
        ;------------------------------------------------------
        clr   @parm1                ; Screen off while reloading color scheme
        seto  @parm2                ; Skip colorizing marked lines
        clr   @parm3                ; Colorize all panes

        bl    @pane.colorscheme.load
                                    ; Reload color scheme
                                    ; \ i  @parm1 = Skip screen off if >FFFF
                                    ; | i  @parm2 = Skip colorizing marked lines
                                    ; |             if >FFFF
                                    ; | i  @parm3 = Only colorize CMDB pane
                                    ; /             if >FFFF                                    
        ;------------------------------------------------------
        ; Prepare for displaying top row
        ;------------------------------------------------------
        mov   @cat.filecount,tmp0      ; Get number of files
        jne   pane.filebrowser.noruler ; \
        b     @pane.filebrowser.exit   ; / Exit if nothing to display
        ;------------------------------------------------------
        ; Reset ruler color on 2nd row
        ;------------------------------------------------------
pane.filebrowser.noruler:
        mov   @tv.ruler.visible,tmp0  ; \ Skip if ruler is off
        jeq   pane.filebrowser.volume ; /

        li    tmp0,vdp.fb.toprow.tat  ; \ i  tmp0 = source address
        mov   @tv.color,tmp1
        srl   tmp1,8
        li    tmp2,80                 ; / i  tmp2 = Number of bytes to fill
        bl    @xfilv                  ; Fill bytes in VDP memory
        ;------------------------------------------------------
        ; Show volume name, number of files, device path
        ;------------------------------------------------------
pane.filebrowser.volume:
        bl    @putat
              byte 0,0
              data txt.volume       ; Display "Volume:...."   

        mov   @cat.volname,tmp0     ; Volume name set?
        jeq   pane.filebrowser.nofiles 
                                    ; No, skip                                    
        bl    @putat
              byte 0,8
              data cat.volname      ; Display volume name
        ;-------------------------------------------------------
        ; Show number of files
        ;-------------------------------------------------------
pane.filebrowser.nofiles:        
        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data cat.filecount    ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf,rambuf + 5,32

        bl    @putat
              byte 0,27
              data rambuf + 5       ; Display number of files
        ;-------------------------------------------------------
        ; Show volume size
        ;-------------------------------------------------------
        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data cat.volsize      ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf,rambuf + 5,32

        bl    @putat
              byte 0,39
              data rambuf + 5       ; Display volume size
        ;-------------------------------------------------------
        ; Show volume free
        ;-------------------------------------------------------
        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data cat.volfree      ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf,rambuf + 5,32

        bl    @putat
              byte 0,52
              data rambuf + 5       ; Display volume free
        ;-------------------------------------------------------
        ; Show volume used
        ;-------------------------------------------------------
        andi  config,>7fff          ; Do not print number
                                    ; (Reset bit 0 in config register)

        bl    @mknum                ; Convert unsigned number to string
              data cat.volused      ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 48               ; | i  p3MSB = ASCII offset
              byte 32               ; / i  p3LSB = Padding character

        bl    @trimnum              ; Trim number to the left
              data rambuf,rambuf + 5,32

        bl    @putat
              byte 0,65
              data rambuf + 5       ; Display volume used
        ;------------------------------------------------------
        ; Draw vertical lines
        ;------------------------------------------------------
pane.filebrowser.lines:        
        bl    @vchar
              byte 1,25                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              byte 1,51                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              data EOL
        ;------------------------------------------------------
        ; Show column headers
        ;------------------------------------------------------              
pane.filebrowser.headers:
        bl    @putat
              byte 1,1
              data txt.header       ; Column 1

        bl    @putat
              byte 1,27
              data txt.header       ; Column 2

        bl    @putat              
              byte 1,53
              data txt.header       ; Column 3

        bl    @hchar                ; Show horizontal lines 
              byte 2,1,1,23         ; Column 1
              byte 2,27,1,23        ; Column 2
              byte 2,53,1,23        ; Column 3
              data eol                         
        ;------------------------------------------------------
        ; Prepare for displaying filenames
        ;------------------------------------------------------        
        mov   @cat.fpicker.idx,tmp0   ; Get current index
        sla   tmp0,1                  ; Make it an offset
        mov   @cat.ptrlist(tmp0),tmp1 ; Get filename list
        jne   pane.filebrowser.show   ; Show filenames if list not empty
        b     @pane.filebrowser.exit  ; Skip on empty list
        ;------------------------------------------------------
        ; Show Catalog
        ;------------------------------------------------------
        ; @cat.var1 = Cutover row and column offset
        ; @cat.var2 = Files per page to display
        ;------------------------------------------------------
pane.filebrowser.show:        
        bl    @at                   ; Set cursor position
              byte 3,1              ; Y=3, X=1

        mov   @fb.scrrows,tmp0      ; \ Determine cutover row for filename
        s     @cmdb.scrrows,tmp0    ; | column list and store in MSB of tmp0.
        mov   tmp0,tmp2             ; | Also use for calculating files per page.
        sla   tmp0,8                ; /
        ori   tmp0,26               ; Set offset for new column in filename list
        mov   tmp0,@cat.var1        ; Save cutover row and offset

        dect  tmp2                  ; Take header lines into account
        mov   tmp2,@cat.norowscol   ; Save number of rows per column
        
        mov   tmp2,tmp3             ; \
        a     tmp3,tmp2             ; | tmp2 = tmp2 * 3
        a     tmp3,tmp2             ; / 
        mov   tmp2,@cat.var2        ; Save files per page to display
        mov   tmp2,@cat.nofilespage ; For later use
        ;------------------------------------------------------
        ; Prepare for calculations
        ;------------------------------------------------------
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2       
        ;------------------------------------------------------
        ; Calc files per column
        ;------------------------------------------------------
        li    tmp0,3
        clr   tmp1                  ; | hi-word 32 bit        
        mov   @cat.nofilespage,tmp2 ; \ Files per page
        div   tmp0,tmp1             ; / Get files per column       
        mov   tmp1,@cat.nofilescol  ; Store files per column in memory                
        ;------------------------------------------------------
        ; Calc number of pages
        ;------------------------------------------------------
        mov   @cat.nofilespage,tmp0 ; \ Files per page
        clr   tmp1                  ; | hi-word 32 bit
        mov   @cat.filecount,tmp2   ; | lo-word 32 bit register (total files)
        div   tmp0,tmp1             ; | Get total pages
        mov   tmp1,@cat.totalpages  ; / Store total pages in memory

        ci    tmp2,0                ; Remainder of division > 0
        jeq   !                     ; No, continue
        inc   @cat.totalpages       ; Yes, there are files on the page
        ;------------------------------------------------------
        ; Calc current page
        ;------------------------------------------------------
!       clr   tmp1                   ; \ hi-word 32 bit
        mov   @cat.fpicker.idx,tmp2  ; | lo-word 32 bit register (current idx)
        div   tmp0,tmp1              ; | Get current page
        jno   pane.filebrowser.divok ; / Store if normal division
        clr   tmp1                   ; We're on 1st page (base 0 offset)
pane.filebrowser.divok:
        inc   tmp1                               ; Consider base 1 offset      
        mov   @cat.currentpage,@cat.previouspage ; Backup current page
        mov   tmp1,@cat.currentpage              ; Store current page in memory
        ;------------------------------------------------------
        ; Calculations done
        ;------------------------------------------------------
pane.filebrowser.calcdone:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        ;------------------------------------------------------
        ; Show filenames
        ;------------------------------------------------------
pane.filebrowser.show.fnlist:
        clr   @waux1                ; \ Set null pointer
                                    ; | Note: putlst only sets @waux1 if 
                                    ; |       tmp2 < entries in list
                                    ; /

        li    tmp3,11               ; Set string padding length

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
        ; Show filetypes list
        ;------------------------------------------------------                                    
pane.filebrowser.show.typelist:
        bl    @at                   ; Set cursor position
              byte 3,13             ; Y=3, X=13

        mov   @cat.fpicker.idx,tmp0 ; Get current index
        li    tmp1,6                ; 6 bytes per entry
        mpy   tmp0,tmp1             ; Calculate offset. Result is in tmp1:tmp2
        mov   tmp2,tmp1             ; Move result to tmp1
        li    tmp0,cat.typelist     ; \ 
        a     tmp0,tmp1             ; / Add base
        mov   @cat.var1,tmp0        ; Get cutover row and column offset
        mov   @cat.var2,tmp2        ; Get number of files to display

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
        ; Show filesize list
        ;------------------------------------------------------
pane.filebrowser.show.sizelist:        
        bl    @at                   ; Set cursor position
              byte 3,21             ; Y=3, X=21

        mov   @cat.fpicker.idx,tmp0  ; Get current index
        sla   tmp0,2                 ; Calculate slot offset (1 entry=4 bytes)
        li    tmp1,cat.sizelist      ; Set base
        a     tmp0,tmp1              ; Add offset

        mov   @cat.var1,tmp0        ; Get cutover row and column offset
        mov   @cat.var2,tmp2        ; Get number of files to display

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
        ; Show filename marker in supported dialogs
        ;------------------------------------------------------
pane.filebrowser.marker:
        mov   @cmdb.dialog,tmp0     ; Get current dialog ID

        ci    tmp0,id.dialog.load   ; \ First supported dialog
        jlt   pane.filebrowser.exit ; / Not in supported dialog range. Skip 

        ci    tmp0,id.dialog.run    ; \ Last supported dialog
        jgt   pane.filebrowser.exit ; / Not in supported dialog range. Skip

        bl    @pane.filebrowser.hilight
                                    ; Show filename marker
                                    ; \ @i @cat.fpicker.idx = 1st file to show 
                                    ; /                       in file browser
        ;---------------------------------------------------------------
        ; Set filename in CMDB pane
        ;---------------------------------------------------------------
        bl    @cpym2m
              data cat.fullfname,cmdb.cmdall,80
                                    ; Copy filename from command line to buffer

        bl    @cmdb.refresh_prompt  ; Refresh command line
        bl    @cmdb.cmd.cursor_eol  ; Cursor at end of input
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

txt.volume    stri  'Volume:             Files:       Size:        Free:        Used:       '
txt.header    stri  'Name        Type   Size'

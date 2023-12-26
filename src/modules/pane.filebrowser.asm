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
        ;------------------------------------------------------
        ; Initialisation
        ;------------------------------------------------------
        mov   @cat.filecount,tmp0     ; Get number of files
        jne   pane.filebrowser.volume ; \
        b     @pane.filebrowser.exit  ; / Exit if nothing to display
        ;------------------------------------------------------
        ; Show volume name, no files, device path
        ;------------------------------------------------------
pane.filebrowser.volume:        
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 640
                                    ; Clear screen

        bl    @putat
              byte 0,0
              data txt.volume       ; Display "Volume: ...."   

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
              byte 0,26
              data rambuf + 5       ; Display number of files
        ;------------------------------------------------------
        ; Show device path
        ;------------------------------------------------------
pane.filebrowser.devicepath:
        mov   @cat.device,tmp0        ; Device path set?
        jeq   pane.filebrowser.lines  ; No, skip display

        bl    @putat
              byte 0,39
              data cat.device         ; Show device path
        ;------------------------------------------------------
        ; Draw vertical lines
        ;------------------------------------------------------
pane.filebrowser.lines:        
        bl    @vchar
              byte 1,26                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              byte 1,54                        ; Starting position YX  
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
              byte 1,29
              data txt.header       ; Column 2

        bl    @putat              
              byte 1,57
              data txt.header       ; Column 3

        bl    @hchar                ; Show horizontal lines 
              byte 2,1,1,11         ; Name
              byte 2,14,1,4         ; Type
              byte 2,20,1,4         ; Size

              byte 2,29,1,11        ; Name
              byte 2,42,1,4         ; Type
              byte 2,48,1,4         ; Size

              byte 2,57,1,11        ; Name
              byte 2,70,1,4         ; Type
              byte 2,76,1,4         ; Size
              data eol                         
        ;------------------------------------------------------
        ; Prepare for displaying filenames
        ;------------------------------------------------------        
        mov   @cat.fpicker.idx,tmp0   ; Get current index
        sla   tmp0,1                  ; Make it an offset
        mov   @cat.ptrlist(tmp0),tmp1 ; Get filename list
        jeq   pane.filebrowser.exit   ; Skip on empty list
        ;------------------------------------------------------
        ; Show Catalog
        ;------------------------------------------------------
        ; @cat.var1 = Cutover row and column offset
        ; @cat.var2 = Files per page to display
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 3,1              ; Y=3, X=1

        mov   @fb.scrrows,tmp0      ; \ Determine cutover row for filename
        s     @cmdb.scrrows,tmp0    ; | column list and store in MSB of tmp0.
        mov   tmp0,tmp2             ; | Also use for calculating files per page.
        sla   tmp0,8                ; /
        ori   tmp0,28               ; Set offset for new column in filename list
        mov   tmp0,@cat.var1        ; Save cutover row and offset

        dect  tmp2                  ; Take header lines into account
        mov   tmp2,@cat.norowscol   ; Save number of rows per column
        
        mov   tmp2,tmp3             ; \
        a     tmp3,tmp2             ; | tmp2 = tmp2 * 3
        a     tmp3,tmp2             ; / 
        mov   tmp2,@cat.var2        ; Save files per page to display
        mov   tmp2,@cat.nofilespage ; Backup. Used for navigation.
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
        inc   tmp1                   ; Consider base 1 offset        
        mov   tmp1,@cat.currentpage  ; Store current page in memory
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
        clr   @waux1                ; \ Set null pointer
                                    ; | Note: putlst only sets @waux1 if 
                                    ; |       tmp2 < entries in list
                                    ; /

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp0 = Cutover row and column offset
                                    ; |           for next column, >0000 for
                                    ; |           single column list
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; | i  tmp2 = Number of strings to display
                                    ; | o  @waux1 = Pointer to next entry  
                                    ; |             in list after displaying
                                    ; /             (tmp2) entries
        ;------------------------------------------------------
        ; Prepare for displaying filesize list
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 3,21             ; Y=3, X=21

        mov   @cat.fpicker.idx,tmp0  ; Get current index
        sla   tmp0,2                 ; Calculate slot offset (1 entry=4 bytes)
        li    tmp1,cat.sizelist      ; Set base
        a     tmp0,tmp1              ; Add offset

        mov   @cat.var1,tmp0        ; Get cutover row and column offset
        mov   @cat.var2,tmp2        ; Get number of files to display

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp0 = Cutover row and column offset
                                    ; |           for next column, >0000 for
                                    ; |           single column list
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; | i  tmp2 = Number of strings to display
                                    ; | o  @waux1 = Pointer to next entry  
                                    ; |             in list after displaying
                                    ; /             (tmp2) entries 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.exit:                
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

txt.volume:       stri  'Volume:            Files:      Device: '
txt.slash:        stri  '/'
txt.header:       stri  'Name         Type  Size'

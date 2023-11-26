* FILE......: pane.filebrowser.asm
* Purpose...: File browser in dialog pane

*---------------------------------------------------------------
* File browser
*---------------------------------------------------------------
* bl   @pane.filebrowser
*--------------------------------------------------------------- 
* INPUT
* @cat.page = Page in catalog to display (base 0())
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
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
        mov   @cat.filecount,tmp0   ; Get number of files
        jeq   pane.filebrowser.exit ; Exit if nothing to display

        c     @cat.page,@cat.maxpage ; Exit if highest page in catalog
        jgt   pane.filebrowser.exit  ; already reached
        ;------------------------------------------------------
        ; Show volume name, no files, device path
        ;------------------------------------------------------
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 640
                                    ; Clear screen

        bl    @putat
              byte 0,0
              data txt.volume       ; Display "Volume: ...."   

        mov   @cat.volname,tmp0        ; Volume name set?
        jeq   pane.filebrowser.nofiles ; No, skip
                                    
        bl    @putat
              byte 0,8
              data cat.volname      ; Display volume name
        ;-------------------------------------------------------
        ; Show number of files, device path
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

        ;bl    @putat
        ;      byte 0,39
        ;      data myfile           ; Show device path
        ;------------------------------------------------------
        ; Draw vertical lines
        ;------------------------------------------------------
pane.filebrowser.lines:        
        bl    @vchar
              byte 1,19                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              byte 1,39                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              byte 1,59                        ; Starting position YX  
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat              
              data EOL
        ;------------------------------------------------------
        ; Prepare for displaying filenames
        ;------------------------------------------------------
        mov   @cat.page,tmp0                   ; Get current page index catalog
        sla   tmp0,1                           ; Make it an offset
        mov   @cat.1stpage1.ptr(tmp0),tmp1     ; Get filename list
        jeq   pane.filebrowser.catpage         ; Skip on empty list
        ;------------------------------------------------------
        ; Show filenames
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 1,1              ; Y=1, X=1

        mov   @fb.scrrows,tmp0      ; \ Determine cutover row for filename
        s     @cmdb.scrrows,tmp0    ; | column list and store in MSB of tmp0.
        mov   tmp0,tmp2             ; | Also use for calculating files per page.
        sla   tmp0,8                ; /
        ori   tmp0,20               ; Set offset for new column in filename list

        sla   tmp2,2                ; Multiply by 4 (because 4 columns per page)

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
                                    ; |
                                    ; | o  @waux1 = Pointer to next entry  
                                    ; |             in list after displaying
                                    ; /             (tmp2) entries

        mov   @waux1,tmp0                    ; Get Pointer
        mov   *tmp0,tmp1                     ; Get content at pointer
        jeq   pane.filebrowser.catpage       ; Skip if end of list reached

        mov   @cat.page,tmp1                 ; Get current page index catalog
        inc   tmp1                           ; Next page
        sla   tmp1,1                         ; Make it an offset
        mov   tmp0,@cat.1stpage1.ptr(tmp1)   ; Save pointer 
        ;-------------------------------------------------------
        ; Catalog page number (part 2)
        ;-------------------------------------------------------
pane.filebrowser.catpage:        
        mov   @cat.1stpage3.ptr,tmp0
        jeq   pane.filebrowser.check.page2
        li    tmp0,2                         ; \ Page 3 (base 0)
        mov   tmp0,@cat.maxpage              ; / 
        jmp   pane.filebrowser.showpage

pane.filebrowser.check.page2:       
        mov   @cat.1stpage2.ptr,tmp0
        jeq   pane.filebrowser.check.page1
        li    tmp0,1                         ; \ Page 2 (base 0)
        mov   tmp0,@cat.maxpage              ; / 
        jmp   pane.filebrowser.showpage

pane.filebrowser.check.page1:
        clr   @cat.maxpage

pane.filebrowser.showpage:
        bl    @putnum
              byte 0,75             ; Show max page number
              data cat.maxpage,rambuf
              byte 49,32

        bl    @putat
              byte 0,78
              data txt.slash        ; Display slash separater

        bl    @mknum                ; Convert unsigned number to string
              data cat.page         ; \ i  p1    = Source
              data rambuf           ; | i  p2    = Destination
              byte 49               ; | i  p3MSB = ASCII offset (Base 1!)
              byte 32               ; / i  p3LSB = Padding character        

        bl    @trimnum              ; Trim number to the left
              data rambuf,rambuf + 5,32

        bl    @putat
              byte 0,77
              data rambuf+5         ; Display page number
 
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

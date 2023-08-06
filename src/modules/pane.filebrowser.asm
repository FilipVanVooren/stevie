* FILE......: pane.filebrowser.asm
* Purpose...: File browser in dialog pane

*---------------------------------------------------------------
* File browser
*---------------------------------------------------------------
* bl   @pane.filebrowser
*--------------------------------------------------------------- 
* INPUT
* none
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
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 640
                                    ; Clear screen

        mov   @cat.filecount,tmp0   ; Get number of files
        jeq   pane.filebrowser.exit ; Exit if nothing to display
        ;------------------------------------------------------
        ; Prepare header
        ;------------------------------------------------------
        bl    @putat
              byte 1,1
              data txt.volume       ; Display "Volume: ...."   

        bl    @putat
              byte 2,1
              data txt.filelist     ; Display "Filename Type Size ...."   

        bl    @vchar
              data >021a                       ; Starting position YX
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 2 ; Y-repeat
              data >0236                       ; Starting position YX
              byte >10                         ; Vertical line char
              byte pane.botrow - cmdb.rows - 2 ; Y-repeat
              data EOL
        ;------------------------------------------------------
        ; Show filenames
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 3,1              ; Y=2, X=1

        li    tmp1,cat.fnlist       ; Get filename list
        mov   @cat.filecount,tmp2   ; Number of filenames to display

        mov   @fb.scrrows,tmp0      ; \ Determine cutover row for filename
        s     @cmdb.scrrows,tmp0    ; | column list and store in MSB of tmp0
        sla   tmp0,8                ; /

        ori   tmp0,28               ; Set offset for new column in filename list

        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp0 = Cutover row and column offset
                                    ; |           for next column, >0000 for
                                    ; |           single column list
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display
        ;------------------------------------------------------
        ; Show volume name, no files, device path
        ;------------------------------------------------------
        mov   @cat.volname,tmp0     ; Volume name set?
        jeq   pane.filebrowser.exit ; No, skip

        bl    @putat
              byte 1,9
              data cat.volname      ; Display volume name
        ;-------------------------------------------------------
        ; Show number of files
        ;-------------------------------------------------------
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
              byte 1,27            
              data rambuf + 5       ; Display number of files
        ;-------------------------------------------------------
        ; Show device path
        ;-------------------------------------------------------
        bl    @putat
              byte 1,41
              data myfile
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.exit:        
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


txt.volume:
        stri  'Volume:            Files:       Device: '
txt.filelist:
        stri  'Filename    Type   Size     Filename    Type   Size     Filename    Type   Size'       

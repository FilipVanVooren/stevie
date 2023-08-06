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
        ;------------------------------------------------------
        ; Prepare header
        ;------------------------------------------------------
        bl    @filv
              data vdp.fb.toprow.sit,32,vdp.sit.size - 640
                                          ; Clear screen

        bl    @putat
              byte 1,1
              data txt.filelist           ; Display "Filename Type Size ...."   

        bl    @vchar
              data >011a                  ; Starting position
              byte >10                    ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              data >0136                  ; Starting position
              byte >10                    ; Vertical line char
              byte pane.botrow - cmdb.rows - 1 ; Y-repeat
              data EOL
        ;------------------------------------------------------
        ; Show files
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 2,1              ; Y=2, X=1

        li    tmp1,>e000
        mov   @fh.records,tmp2
        dect  tmp2

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

pane.filebrowser.exit:
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


txt.filelist:
        stri  'Filename    Type   Size     Filename    Type   Size     Filename    Type   Size'       

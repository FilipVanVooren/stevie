* FILE......: pane.filebrowser.hlight.asm
* Purpose...: File browser. Highlight current File in list

*---------------------------------------------------------------
* File browser
*---------------------------------------------------------------
* bl   @pane.filebrowser.hlight
*--------------------------------------------------------------- 
* INPUT
* @cat.fpicker.idx = 1st file to show in file browser
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2
********|*****|*********************|**************************
pane.filebrowser.hilight:
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
        mov   @cat.filecount,tmp0           ; Get number of files
        jne   !                             ; \
        jmp   pane.filebrowser.hilight.exit ; / Exit if nothing to display
        ;------------------------------------------------------
        ; Determine offset on current page
        ;------------------------------------------------------
!       mov   @cat.shortcut.idx,tmp0 ; Get index
        c     tmp0,@cat.nofilespage  ; Are we on 1st page?
        jlt   pane.filebrowser.hilight.rowcol
                                     ; Yes, skip page calculation

        mov   tmp0,tmp1              ; \ Prepare for division.
        clr   tmp0                   ; / MSW=0, LSW=index value
        div   @cat.nofilespage,tmp0  ; \ Calculate offset on current page
                                     ; / tmp0 = page number, tmp1 = offset

        mov   @cat.currentpage,@cat.previouspage
        mov   tmp0,@cat.currentpage
        mov   tmp1,tmp0              ; Get offset on current page
        ;------------------------------------------------------
        ; Calculate column/row offset based on offset on current page
        ;------------------------------------------------------
pane.filebrowser.hilight.rowcol:        
        mov   tmp0,tmp1              ; Get index in filename list in LSW
        clr   tmp0                   ; Clear MSW
        div   @cat.norowscol,tmp0    ; \ Do division on 32 bit word.
                                     ; / tmp0 is column, tmp1 is row offset
        movb  @tmp0lb,@tmp1hb        ; Combine column & row in single word                                   
        mov   @cat.hilit.colrow,@cat.hilit.colrow2 
                                     ; Backup current column & row 
        mov   tmp1,@cat.hilit.colrow ; Save new column & row
        ;------------------------------------------------------
        ; Remove previous file marker
        ;------------------------------------------------------
pane.filebrowser.hilight.remove:                
        mov   @cat.hilit.colrow2,tmp0            ; Get column/row offsets
        jeq   pane.filebrowser.hilight.draw.page ; Not set, skip remove marker

        srl   tmp0,8                 ; MSB to LSB. Column value in LSB
        li    tmp1,28                ; Offset next column
        mpy   tmp0,tmp1              ; tmp2 = col*28
        sla   tmp2,8                 ; LSB to MSB

        movb  @cat.hilit.colrow2+1,@tmp2lb ; Get row into tmp2 LSB
        swpb  tmp2                         ; Column/row to YX
        ai    tmp2,>0300                   ; Add offset

        mov   tmp2,@wyx              ; Set cursor position
        bl    @putstr                ; Put string 
              data nomarker          ; Remove marker
        ;------------------------------------------------------
        ; Refresh filelist when moved to other page
        ;------------------------------------------------------
pane.filebrowser.hilight.draw.page:
        c     @cat.currentpage,@cat.previouspage
        jeq   pane.filebrowser.hilight.draw.marker
        mov   @cat.shortcut.idx,@cat.fpicker.idx 
        bl    @pane.filebrowser
        ;------------------------------------------------------
        ; Draw file marker
        ;------------------------------------------------------
pane.filebrowser.hilight.draw.marker:
        mov   @cat.hilit.colrow,tmp0
        srl   tmp0,8                 ; MSB to LSB. Column value in LSB
        li    tmp1,28                ; Offset next column
        mpy   tmp0,tmp1              ; tmp2 = col*28
        sla   tmp2,8                 ; LSB to MSB

        movb  @cat.hilit.colrow+1,@tmp2lb ; Get row into tmp2 LSB
        swpb  tmp2                        ; Column/row to YX
        ai    tmp2,>0300                  ; Add offset

        mov   tmp2,@wyx
        bl    @putstr
              data txt.cmdb.prompt   ; Marker
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.hilight.exit:                
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

nomarker  stri  ' '
       
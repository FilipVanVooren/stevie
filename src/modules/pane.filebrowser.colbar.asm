* FILE......: pane.filebrowser.colbar.asm
* Purpose...: File browser. Draw or remove color bar on selected file.

*---------------------------------------------------------------
* Draw color bar on selected file
*---------------------------------------------------------------
* bl   @pane.filebrowser.colbar
*--------------------------------------------------------------- 
* INPUT
* @wyx = Current position
* tmp0 = Color combination to show (in LSB)
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3
********|*****|*********************|**************************
pane.filebrowser.colbar:
        .pushregs 3                 ; Push return address and registers on stack
        dect  stack
        mov   @wyx,*stack           ; Push cursor position      
        ;------------------------------------------------------
        ; Calculate position
        ;------------------------------------------------------
        mov   tmp0,tmp3             ; Save color combination
        bl    @yx2pnt               ; Get VDP PNT address for current YX pos.
                                    ; \ i  @wyx = Cursor position
                                    ; / o  tmp0 = VDP target address

        ai    tmp0,vdp.tat.base     ; Add offset for TAT
        mov   tmp0,@waux1           ; Backup TAT position
        ;------------------------------------------------------
        ; Set color of "[]" maker
        ;------------------------------------------------------
        mov   tmp3,tmp1
        bl    @xvputb               ; Write single byte to VDP
                                    ; i \  tmp0 = Destination VFP address
                                    ; i /  tmp1 = byte to write
        ;------------------------------------------------------
        ; Set background color of color bar
        ;------------------------------------------------------
        mov   @waux1,tmp0           ; Restore TAT position
        inc   tmp0                  ; Skip marker  
        mov   tmp3,tmp1             ; Restore color combination
        li    tmp2,23               ; 23 bytes to fill

        bl    @xfilv                ; Fill colors
                                    ; i \  tmp0 = start address
                                    ; i |  tmp1 = byte to fill
                                    ; i /  tmp2 = number of bytes to fill
        ;------------------------------------------------------
        ; Set color of "]" maker
        ;------------------------------------------------------
        mov   @waux1,tmp0           ; Restore TAT position
        ai    tmp0,24               ; End marker
        mov   tmp3,tmp1             ; Restore color combination
        bl    @xvputb               ; Write single byte to VDP
                                    ; i \  tmp0 = Destination VFP address
                                    ; i /  tmp1 = byte to write
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.colbar.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        .popregs 3                  ; Pop registers and return to caller                             

*---------------------------------------------------------------
* Remove filepicker color bar (if visible)
*---------------------------------------------------------------
* bl   @pane.filebrowser.colbar.remove
*--------------------------------------------------------------- 
* INPUT
* @cat.barpos = YX position of color bar
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2
********|*****|*********************|**************************
pane.filebrowser.colbar.remove:
        .pushregs 2                 ; Push return address and registers on stack
        dect  stack
        mov   @wyx,*stack           ; Push cursor position      
        ;-------------------------------------------------------
        ; Remove filepicker color bar (if visible)
        ;-------------------------------------------------------
        mov   @cat.barpos,tmp0      ; Get color bar position
        jeq   pane.filebrowser.colbar.remove.exit
                                    ; If not visible, exit  

        mov   tmp0,@wyx             ; Set cursor position              
        mov   @tv.color,tmp0        ; \ Get color combination (only MSB counts)
        swpb  tmp0                  ; /

        bl    @pane.filebrowser.colbar
                                    ; Draw column bar 
                                    ; i \  tmp0 = color combination
                                    ; i /  @wyx = Cursor position
        ;-------------------------------------------------------
        ; Remove "[" marker
        ;-------------------------------------------------------
        bl    @putstr               ; Put string 
              data nomarker         ; Remove "[" marker
        ;------------------------------------------------------
        ; Calculate "]" marker position
        ;------------------------------------------------------
        mov   @cat.barpos,tmp0      ; \ 
        ai    tmp0,24               ; | Calculate position
        mov   tmp0,@wyx             ; /
        ;-------------------------------------------------------
        ; Remove "]" marker
        ;-------------------------------------------------------
        bl    @putstr               ; Put string 
              data nomarker         ; Remove "[" marker

        clr   @cat.barpos           ; Clear color bar position  
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.colbar.remove.exit:
        mov   *stack+,@wyx          ; Pop cursor position
        .popregs 2                  ; Pop registers and return to caller                        

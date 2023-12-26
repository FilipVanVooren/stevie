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
!       mov   @cat.fpicker.idx,tmp0 ; Get index
        mov   @cat.currentpage,tmp1 ; Get current page
        mpy   @cat.nofilespage,tmp1 ; \ Calculate offset on current page
                                    ; / result is in 32bit word (tmp2)
        s     tmp2,tmp0             ; Get offset on current page
        ;------------------------------------------------------
        ; Calculate row/column based on offset on current page
        ;------------------------------------------------------
        mov   tmp0,tmp1
        clr   tmp0
        div   @cat.norowscol,tmp0
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
pane.filebrowser.hilight.exit:                
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

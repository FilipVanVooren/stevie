* FILE......: fm.browse.fmname.next
* Purpose...: File Manager - File browse support routines

***************************************************************
* fm.browse.fname.next
* Pick next filename in catalog filename list
***************************************************************
* bl   @fm.browse.fname.next
*--------------------------------------------------------------
* INPUT
* @cat.shortcut.idx = Index in catalog filename pointer list
*--------------------------------------------------------------- 
* OUTPUT
* @cat.fullfname = Combined string with device & filename
* @cat.outparm1  = >FFFF if skipped, >0000 on normal exit
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fm.browse.fname.next:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1             
        ;------------------------------------------------------
        ; Next filename in catalog filename list
        ;------------------------------------------------------
        clr   @outparm1              ; Reset skipped flag               
        mov   @cat.shortcut.idx,tmp0 ; \ Get current file index 
        inc   tmp0                   ; / Base 1
        c     tmp0,@cat.filecount    ; Last file reached ?
        jlt   !                      ; No, continue
        jmp   fm.browse.fname.next.skip 
                                     ; Yes, exit early

!       inc   tmp0                   ; Next file in catalog
        ;------------------------------------------------------
        ; Do division for page/offset calculation
        ;------------------------------------------------------
        mov   tmp0,tmp1             ; \ Prepare for division.
        clr   tmp0                  ; / MSW=0, LSW=index value
        div   @cat.nofilespage,tmp0 ; \ Calculate offset on current page
                                    ; / tmp0 = page number, tmp1 = offset
        jno   fm.browse.fname.next.divok
                                    ; No overflow, continue
        jmp   fm.browse.fname.next.set
                                    ; Overflow, just set filename
        ;------------------------------------------------------
        ; Division ok, now do page check
        ;------------------------------------------------------
fm.browse.fname.next.divok:
        inc   tmp0                      ; Base 1        
        c     tmp0,@cat.currentpage     ; Stay on page?
        jeq   fm.browse.fname.next.set  ; Yes, skip paging
        ;------------------------------------------------------
        ; Next page and filename in catalog
        ;------------------------------------------------------
fm.browse.fname.next.page:
        inc   @cat.currentpage      ; Next page

        a     @cat.nofilespage,@cat.fpicker.idx
                                    ; Calculate 1st filename on page

        mov   @cat.fpicker.idx,@cat.shortcut.idx

        bl    @pane.filebrowser     ; Refresh filebrowser pane

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        jmp   fm.browse.fname.next.exit
        ;------------------------------------------------------
        ; Next filename in catalog
        ;------------------------------------------------------
fm.browse.fname.next.set:
        inc   @cat.shortcut.idx     ; Next file in catalog

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename
        
        jmp   fm.browse.fname.next.exit
        ;------------------------------------------------------
        ; Skip next file
        ;------------------------------------------------------        
fm.browse.fname.next.skip:
        seto  @outparm1             ; Set skipped flag
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.next.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

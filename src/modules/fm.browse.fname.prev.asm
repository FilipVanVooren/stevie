* FILE......: fm.browse.fmname.prev
* Purpose...: File Manager - File browse support routines

***************************************************************
* fm.browse.fname.prev
* Pick previous filename in catalog filename list
***************************************************************
* bl   @fm.browse.fname.prev
*--------------------------------------------------------------
* INPUT
* @cat.shortcut.idx = Index in catalog filename pointer list
*--------------------------------------------------------------- 
* OUTPUT
* @cat.fullfname = Combined string with device & filename
* @cat.outparm1  = >FFFF if skipped, >0000 on normal exit
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
fm.browse.fname.prev:
        .pushregs 1                 ; Push return address and registers on stack
        ;------------------------------------------------------
        ; Previous filename in catalog filename list
        ;------------------------------------------------------
        clr   @outparm1             ; Reset skipped flag        
        mov   @cat.shortcut.idx,tmp0
        jeq   fm.browse.fname.prev.skip 
                                    ; Skip if already first file in catalog

        dec   tmp0                  ; Previous file in catalog                                    
        ;------------------------------------------------------
        ; Do division for page/offset calculation
        ;------------------------------------------------------
        mov   tmp0,tmp1             ; \ Prepare for division.
        clr   tmp0                  ; / MSW=0, LSW=index value
        div   @cat.nofilespage,tmp0 ; \ Calculate offset on current page
                                    ; / tmp0 = page number, tmp1 = offset
        jno   fm.browse.fname.prev.divok
                                    ; No overflow, continue
        jmp   fm.browse.fname.prev.set
                                    ; Overflow, just set filename
        ;------------------------------------------------------
        ; Division ok, now do page check
        ;------------------------------------------------------
fm.browse.fname.prev.divok:
        inc   tmp0                      ; Base 1        
        c     tmp0,@cat.currentpage     ; Stay on page?
        jeq   fm.browse.fname.prev.set  ; Yes, skip paging
        ;------------------------------------------------------
        ; Previous page and filename in catalog
        ;------------------------------------------------------
fm.browse.fname.prev.page:
        dec   @cat.currentpage      ; Previous page
        dec   @cat.shortcut.idx     ; Previous file in catalog

        s     @cat.nofilespage,@cat.fpicker.idx
                                    ; Calculate 1st filename on page

        bl    @pane.filebrowser     ; Refresh filebrowser pane

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @tv.devpath = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        jmp   fm.browse.fname.prev.exit
        ;------------------------------------------------------
        ; Previous filename in catalog
        ;------------------------------------------------------
fm.browse.fname.prev.set:        
        dec   @cat.shortcut.idx     ; Previous file in catalog

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @tv.devpath = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        jmp   fm.browse.fname.prev.exit
        ;------------------------------------------------------
        ; Skip previous file
        ;------------------------------------------------------        
fm.browse.fname.prev.skip:
        seto  @outparm1             ; Set skipped flag                                            
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.prev.exit:
        .popregs 1                  ; Pop registers and return to caller                

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
        ;------------------------------------------------------
        ; Next filename in catalog filename list
        ;------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0     ; \ Get current file index 
        inc   tmp0                       ; / Base 1
        c     tmp0,@cat.filecount        ; Last file reached ?
        jlt   !                          ; No, continue
        jmp   fm.browse.fname.next.skip  ; Yes, exit early
!       inc   @cat.shortcut.idx          ; Next file in catalog

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename
        
        clr   @outparm1             ; Reset skipped flag
        jmp   fm.browse.fname.next.exit
        ;------------------------------------------------------
        ; Skip doing next file
        ;------------------------------------------------------        
fm.browse.fname.next.skip:
        seto  @outparm1             ; Set skipped flag
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.next.exit:
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

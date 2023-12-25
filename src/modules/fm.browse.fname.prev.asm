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
* tmp0
********|*****|*********************|**************************
fm.browse.fname.prev:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        ;------------------------------------------------------
        ; Previous filename in catalog filename list
        ;------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0
        jeq   fm.browse.fname.prev.exit  ; Skip if first file in catalog reached
        dec   @cat.shortcut.idx          ; Previous file in catalog

        bl    @fm.browse.fname.set  ; Create string with device & filename
                                    ; \ i  @cat.device = Current device name
                                    ; | i  @cat.shortcut.idx = Index in catalog 
                                    ; |        filename pointerlist
                                    ; | 
                                    ; | o  @cat.fullfname = Combined string with
                                    ; /        device & filename

        clr   @outparm1             ; Reset skipped flag
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
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

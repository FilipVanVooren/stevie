* FILE......: fm.browse.fname.set
* Purpose...: File Manager - File browse support routines

***************************************************************
* fm.browse.fname.set
* Set device and filename
***************************************************************
* bl   @fm.browse.fname.set
*--------------------------------------------------------------
* INPUT
* @cat.device       = Current device name
* @cat.shortcut.idx = Index in catalog filename pointerlist
*--------------------------------------------------------------- 
* OUTPUT
* @cat.fullfname = Combined string with device & filename
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1
********|*****|*********************|**************************
fm.browse.fname.set:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0        
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;------------------------------------------------------
        ; Prepare
        ;------------------------------------------------------
        bl    @film
              data cat.fullfname,0,80 
                                    ; Clear device and filename
        ;------------------------------------------------------
        ; Set device name
        ;------------------------------------------------------
        li    tmp0,cat.device
        li    tmp1,cat.fullfname        
        movb  @cat.device,tmp2      ; Get length byte of device name
        srl   tmp2,8                ; MSB to LSB
        jeq   fm.browse.fname.set.exit
                                    ; Exit early if no device set

        inc   tmp2                  ; Include length-byte prefix
        mov   tmp2,@cat.var1        ; Backup value

        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy

        mov   @cat.filecount,tmp0      ; \ Do not append filename if
        jeq   fm.browse.fname.set.exit ; / catalog is empty anyway.
        ;------------------------------------------------------
        ; Get pointer from filename list in catalog
        ;------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0  ; Get index 
        sla   tmp0,1                  ; Word align
        mov   @cat.ptrlist(tmp0),tmp0 ; Get pointer

        mov   @cat.var1,tmp1        ; Restore value
        ai    tmp1,cat.fullfname    ; Calc destination for copy operation

        movb  *tmp0+,tmp2           ; Get length-byte and skip
        srl   tmp2,8                ; MSB to LSB
        jeq   fm.browse.fname.set.exit 
                                    ; Exit early if no filename set
        ;------------------------------------------------------
        ; Append filename to device name
        ;------------------------------------------------------        
        mov   tmp2,@cat.var1        ; Save filename length

        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; Adjust length-byte prefix to include device+filename
        ;------------------------------------------------------
        mov   @cat.var1,tmp0        ; Get filename length
        sla   tmp0,8                ; LSB to MSB
        a     tmp0,@cat.fullfname   ; Set length-byte prefix
        ;------------------------------------------------------
        ; Add final dot '.' to filename if it's a directory
        ;------------------------------------------------------
        mov   @cat.shortcut.idx,tmp0   ; Get index 
        movb  @cat.ftlist(tmp0),tmp0   ; Get file type
        srl   tmp0,8                   ; MSB to LSB
        ci    tmp0,6                   ; Is it a directory?
        jne   fm.browse.fname.set.exit ; Exit if not a directory

        movb  @cat.fullfname,tmp0      ; Get length-byte
        srl   tmp0,8                   ; MSB to LSB
        inc   tmp0                     ; Increase string length
        swpb  tmp0                     ; LSB to MSB
        movb  tmp0,@cat.fullfname      ; Set length-byte
        srl   tmp0,8                   ; MSB to LSB
        ai    tmp0,cat.fullfname       ; Add base to offset
        li    tmp1,>2e00               ; \ Dot character in MSB
        movb  tmp1,*tmp0               ; / Add dot to the end
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.fname.set.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller        

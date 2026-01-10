* FILE......: fm.browse.updir
* Purpose...: File Manager - File browse support routines

***************************************************************
* fm.browse.updir
* Go up one directory level
***************************************************************
* bl   @fm.browse.updir
*--------------------------------------------------------------
* INPUT
* @tv.devpath = Current device name
*--------------------------------------------------------------- 
* OUTPUT
* @outparm1 = >0000 if at root or no subdirectory on device.
*             >ffff if directory successfully changed.
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3
********|*****|*********************|**************************
fm.browse.updir:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1             
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        dect  stack
        mov   tmp3,*stack           ; Push tmp3                
        ;------------------------------------------------------
        ; Get device name/path
        ;------------------------------------------------------
        clr   @outparm1             ; Clear success flag        
        movb  @tv.devpath,tmp0      ; Get length current device name/path
        srl   tmp0,8                ; MSB to LSB
        mov   tmp0,tmp1             ; Save length
        ai    tmp1,tv.devpath       ; Point to last character
        mov   tmp0,tmp2             ; Set counter
        clr   tmp3                  ; Clear dot count        
        li    tmp0,>2e00            ; Dot '.' character in MSB
        ;------------------------------------------------------
        ; Count dots in device path
        ;------------------------------------------------------
fm.browse.updir.loop1:
        cb    *tmp1,tmp0            ; Is it a dot?
        jne   fm.browse.updir.loop1.cont 
                                    ; No match, continue loop
        inc   tmp3                  ; Match. Increment dot count
        ci    tmp3,2                ; 2nd dot encountered?
        jne   fm.browse.updir.loop1.cont
                                    ; No. Continue loop
        mov   tmp1,@cat.var1        ; Yes. Save position of 2nd dot
fm.browse.updir.loop1.cont:
        dec   tmp1                  ; Move to previous character
        dec   tmp2                  ; Decrement counter
        jgt   fm.browse.updir.loop1 ; Previous character
        ;------------------------------------------------------
        ; Exit early if at root or not subdirectory on device
        ;------------------------------------------------------        
        ci    tmp3,2                ; More than one dot?
        jlt   fm.browse.updir.exit  ; No. Exit early
        ;------------------------------------------------------
        ; Remove last part of device name/path
        ;------------------------------------------------------        
        mov   @cat.var1,tmp1        ; Get position of 2nd dot
        ai    tmp1,-tv.devpath      ; Calculate length of device name/path
        mov   tmp1,@cat.var2        ; Backup length of device name/path
        sla   tmp1,8                ; LSB to MSB
        movb  tmp1,@tv.devpath      ; Set new length
        seto  @outparm1             ; Set success flag
        ;------------------------------------------------------
        ; Clear rest of device name/path
        ;------------------------------------------------------
        mov   @cat.var1,tmp0        ; Address in memory
        inc   tmp0                  ; Skip 2nd dot
        clr   tmp1                  ; Fill with nulls
        li    tmp2,80
        s     @cat.var2,tmp2        ; Limit to 80 characters

        bl    @xfilm                ; \ Fill memory
                                    ; | i  tmp0 = Memory start address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Number of bytes to fill
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.browse.updir.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0 
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

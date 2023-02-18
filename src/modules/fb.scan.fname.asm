* FILE......: fb.scan.fname.asm
* Purpose...: Scan current line for possible filename

***************************************************************
* fb.scan.fname
* Scan current line for possible filename
***************************************************************
*  bl   @fb.scan.fname
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* @cmdb.dflt.fname = Pointer to string with default filename
*--------------------------------------------------------------
* Register usage
* tmp0,tmp1,tmp2,tmp3,tmp4,r2,r3
********|*****|*********************|**************************
fb.scan.fname:
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
        dect  stack
        mov   tmp4,*stack           ; Push tmp4
        dect  stack
        mov   r2,*stack             ; Push r2
        dect  stack
        mov   r3,*stack             ; Push r3
        ;-------------------------------------------------------
        ; Initialisation
        ;-------------------------------------------------------
fb.scan.fname.copy:
        bl    @film
              data cmdb.dflt.fname,>00,80
                                    ; Clear filename in buffer

        bl    @fb.calc.pointer      ; Calculate position in frame buffer
                                    ; \ i   @fb.top      = Address top row in FB
                                    ; | i   @fb.topline  = Top line in FB
                                    ; | i   @fb.row      = Current row in FB
                                    ; |                  (offset 0..@fb.scrrows)
                                    ; | i   @fb.column   = Current column in FB
                                    ; | i   @fb.colsline = Columns per line FB 
                                    ; | 
                                    ; / o   @fb.current  = Updated pointer
                                    
        ; Register usage in following code
        ; 
        ; tmp0 = Pointer to first character in framebuffer line
        ; tmp1 = Destination address for filename copy
        ; tmp2 = Pointer to last character in framebuffer line
        ; tmp3 = Pointer to first character in valid devices string
        ; tmp4 = Pointer to last character in valid devices string
        ; r3   = Temporary storage

        ;-------------------------------------------------------
        ; (1) Prepare for lookup
        ;-------------------------------------------------------
        clr   r2                    ; Length counter
        li    r3,>2c00              ; Delimiter is ASCII 44 (>2c) ","

        mov   @fb.current,tmp0      ; Start address in framebuffer
        mov   tmp0,tmp2             ; \ calculate end address of
        a     @fb.row.length,tmp2   ; / source line in framebuffer

        li    tmp1,cmdb.dflt.fname  ; Destination for character copy
        inc   tmp1                  ; Skip length byte, will be set later

        li    tmp3,def.devices      ; Get string with valid devices
        mov   *tmp3,tmp4            ; \ Get length byte, skipping
        srl   tmp4,8                ; / 1st following character
        a     tmp3,tmp4             ; Calc end address of valid devices
        inct  tmp3                  ; Skip length byte and following char
        ;-------------------------------------------------------
        ; (2) Compare char in framebuffer with device lookup
        ;-------------------------------------------------------
fb.scan.fname.device.loop:
        cb    *tmp0,*tmp3           ; Does char match with lookup?
        jne   fb.scan.fname.nextdev.loop 
                                    ; No, look for next device (3)

        movb  *tmp0+,*tmp1+         ; Copy byte to destination
        inc   r2                    ; Increase length

        inc   tmp3                  ; Next char in lookup
        cb    *tmp3,r3              ; Did we find the delimiter?
        jeq   fb.scan.fname.copy.rest
                                    ; Yes, device match. Now copy rest (4)
        
        c     tmp3,tmp4             ; At end in lookup string?
        jeq   fb.scan.fname.exit    ; Yes, exit without match

        c     tmp0,tmp2             ; End of line reached?
        jle   fb.scan.fname.device.loop
                                    ; Not yet, next iteration (2)
                               
        jmp   fb.scan.fname.exit    ; Yes, exit without match
        ;-------------------------------------------------------
        ; (3) Goto next device in lookup string
        ;-------------------------------------------------------
fb.scan.fname.nextdev.loop:        
        cb    *tmp3+,r3             ; Did we find the delimiter (comma)?
        jeq   fb.scan.fname.device.loop
                                    ; Yes, exit here and start compare (2)

        c     tmp3,tmp4             ; End of lookup string reached?
        jgt   fb.scan.fname.exit    ; Yes, exit without match!

        jmp   fb.scan.fname.nextdev.loop
                                    ; No, next char in lookup string
        ;------------------------------------------------------
        ; (4) Copy rest of device/filename
        ;------------------------------------------------------
fb.scan.fname.copy.rest:
        nop                         ; Placeholder for now
fb.scan.fname.copy.rest.loop:
        movb  *tmp0+,*tmp1+         ; Copy byte to destination
        inc   r2                    ; Increase length        
        ;------------------------------------------------------
        ; (4a) Look for delimiters SPACE and NULL
        ;------------------------------------------------------
        li    r3,>2000              ; \ Delimiters ASCII 32 (>20) " "
                                    ; /            ASCII 00 (>00) ""
        cb    *tmp0,r3
        jeq   fb.scan.fname.done    ; Match, file name copy done (5)
        swpb  r3
        cb    *tmp0,r3
        jeq   fb.scan.fname.done    ; Match, file name copy done (5)

        ;------------------------------------------------------
        ; (4b) Look for delimiters " and '
        ;------------------------------------------------------ 
        li    r3,>2227              ; \ Delimiters ASCII 34 (>22) """
                                    ; /            ASCII 39 (>27) "'" 

        cb    *tmp0,r3
        jeq   fb.scan.fname.done    ; Match, file name copy done (5)
        swpb  r3
        cb    *tmp0,r3
        jeq   fb.scan.fname.done    ; Match, file name copy done (5)

        c     tmp0,tmp2             ; End of line reached?
        jle   fb.scan.fname.copy.rest.loop
                                    ; Not yet, next iteration (4)

        jmp   fb.scan.fname.done    ; File name copy done (5)
        ;------------------------------------------------------
        ; Asserts failed
        ;------------------------------------------------------
fb.scan.fname.crash
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system  
        ;------------------------------------------------------
        ; (5) File name copy done
        ;------------------------------------------------------             
fb.scan.fname.done:
        sla   r2,8                  ; Left align
        movb  r2,@cmdb.dflt.fname   ; Set length byte
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fb.scan.fname.exit:
        mov   *stack+,r3            ; Pop r3
        mov   *stack+,r2            ; Pop r2        
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0          
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

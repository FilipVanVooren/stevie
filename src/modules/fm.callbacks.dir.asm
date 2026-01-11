* FILE......: fm.callbacks.dir.asm
* Purpose...: File Manager - Callbacks for drive/directory listing

*===============================================================================
* Catalog format 
* Details: http://www.hexbus.com/ti99geek/Doc/readingdirectories.html#readdir
*
* Floating point numbers are in RADIX 100 format.
* Details: https://www.unige.ch/medecine/nouspikel/ti99/reals.htm#Radix%20100
*
*
* Drive/Device catalog format:
* 
*    RECORD 0 -> volume label and device information
*   
*    hex   01234567
*    0008  ........
*    0010  ........
*    0018  ........
*    0020  ........
*    0028  ........
*    0030  ........
*    0038  ........
*   
*   
*    RECORD 1...n -> file and directory information
*   
*    hex   01234567
*    0008  ABLSSSSS     
*    0010  SSSSSS1E     
*    0018  MMMMMMM2
*    0020  EMMMMMMM
*    0028  3EMMMMMM
*    0030  M.......
*    
*    A=>00 \ Record size 38 bytes (>26) or 146 bytes (>92).
*    B=>26 / Note: only 146 bytes if device supports timestamps.
*    L=>xx String length (max. >0A)
*    S=>xx String ASCII char (filename)
*    
*    FILETYPE
*    
*    1=>08 Float size     1 byte
*    E=>xx Float exponent 1 byte
*    M=>xx Float mantissa 7 bytes
*    	1 - Record type:
*    		0 = Volume label
*    		1 = File type Display/Fixed
*    		2 = File type Display/Variable
*    		3 = File type Internal/Fixed
*    		4 = File type Internal/Variable
*    		5 = File type Program (binary)
*    		6 = Directory
*    		If a file type < 0 it means that the file is write protected.
*    
*    FILESIZE
*
*    2=>08 Float 2 size 
*    F=>xx Float 8 bytes
*    	2 - If Record type is Volume label (0): Size of the device in 256 bytes
*    	                                        sectors
*    	    If Record type is File type  (1-5): Number of 256 bytes sectors the
*    	                                        file occupies
*    	    If Record type is Directory   (6) : Number of 256 bytes sectors the
*    	                                        directory index occupies
*    	                                        (2*sectors/alocation unit) but
*    	                                        some peripherals just returns 0!
*    
*    RECORDSIZE IN FILETYPE
*
*    3=>08 Float 3 size 
*    F=>xx Float 8 bytes
*    	3 - If Record type is Volume label (0): Number of free 256 bytes sectors
*    	    If Record type is File type  (1-4): Maximum record length of file
*    	    If Record type is Program file (5): The value 0, but on some
*    	                                        peripherals the size in bytes!
*    	    If Record type is Directory    (6): The value 0
*===============================================================================


***************************************************************
* fm.dir.callback1
* Callback function "Before open file"
***************************************************************
* bl  @fm.dir.callback1
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback1
*--------------------------------------------------------------
* Register usage
* tmp0
********|*****|*********************|**************************
fm.dir.callback1:
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
        ; Prepare for reading directory
        ;------------------------------------------------------
        clr   @fh.offsetopcode      ; Allow all devices (copy to VDP)
        clr   @fh.records           ; Reset record count
        clr   @cat.filecount        ; Reset number of files
        clr   @cat.fpicker.idx      ; Reset current file in list

        li    tmp0,cat.fnlist       ; \ Set RAM destination address 
        mov   tmp0,@fh.dir.rec.ptr  ; / for storing directory entries
        ;------------------------------------------------------
        ; Show reading directory message
        ;------------------------------------------------------
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /

        bl    @putat
              byte pane.botrow,0
              data txt.readdir      ; Display "Reading catalog..."

        bl    @at
              byte pane.botrow,19   ; Set cursor YX position

        mov   @fh.fname.ptr,tmp1    ; Get pointer to device/directory name
        bl    @xutst0               ; \ Display length-prefixed string
                                    ; / tmp1 = pointer to length-prefixed string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback1.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* fm.dir.callback2
* Callback function "Read line from file"
***************************************************************
* bl  @fm.dir.callback2
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback2
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1, tmp2, tmp3, tmp4
********|*****|*********************|**************************
fm.dir.callback2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0W
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2        
        dect  stack
        mov   tmp3,*stack           ; Push tmp3
        dect  stack
        mov   tmp4,*stack           ; Push tmp4        
        ;------------------------------------------------------
        ; Check if volume name
        ;------------------------------------------------------
        mov   @fh.records,tmp0           ; \
        ci    tmp0,1                     ; | Skip to fileindex if it's
        jeq   fm.dir.callback2.volname   ; / not the volume name
        ;------------------------------------------------------
        ; Sanity check: 127 files per directory only
        ;------------------------------------------------------
        ci    tmp0,128 
        jlt   fm.dir.callback2.fileindex
        seto  @fh.circbreaker        ; Set circuit-breaker flag                                   
        b     @fm.dir.callback2.exit ; Exit callback without crashing       
        ;------------------------------------------------------
        ; Handle volume name
        ;------------------------------------------------------
fm.dir.callback2.volname:        
        li    tmp0,rambuf+2          ; Source address
        li    tmp1,cat.volname       ; Destination address
        movb  @rambuf+2,tmp2         ; Get string length 
        srl   tmp2,8                 ; MSB to LSB        
        jgt   !                      ; Only copy volume name if set
        b     @fm.dir.callback2.exit ; Exit
        ;------------------------------------------------------
        ; Copy volume name to final destination
        ;------------------------------------------------------
!       inc   tmp2                  ; Include prefixed length-byte
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy
        ;------------------------------------------------------
        ; Get volume size
        ;------------------------------------------------------
fm.dir.callback2.volsize:
        li    tmp0,rambuf + >12
        movb  *tmp0,tmp1            ; Get Float size byte     

        inc   tmp0                  ; Skip float size byte
        movb  *tmp0+,tmp1           ; Get float exponent byte
        srl   tmp1,8                ; MSB to LSB

        movb  *tmp0+,tmp2           ; Get float mantissa byte
        srl   tmp2,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Turn radix 100 floating point into hex number
        ;------------------------------------------------------        
        ai    tmp1,-64              ; Subtract radix 100 exponent bias >40        
        jgt   fm.dir.callback2.volsize.radix100.part1
                                    ; Handle 1st byte if exponent > 1

        mov   tmp2,tmp1             ; No multiplication needed
        jmp   fm.dir.callback2.volsize.store
        ;------------------------------------------------------
        ; Handle mantissa (byte 1) if exp>1
        ;------------------------------------------------------        
fm.dir.callback2.volsize.radix100.part1:
        li    tmp4,100              ; \ Multiply 1st byte mantissa by 100
        mpy   tmp4,tmp2             ; | Result is in 32 bit register tmp2:tmp3
        mov   tmp3,tmp2             ; / Move LSW to MSW
        dec   tmp1                  ; Decrement exponent
        jgt   fm.dir.callback2.volsize.radix100.part1
                                    ; Next iteration if exponent > 0
        ;------------------------------------------------------
        ; Handle mantissa (byte 2) if exp>1, otherwise (byte 1)
        ;------------------------------------------------------   
fm.dir.callback2.volsize.radix100.part2:
        movb  *tmp0+,tmp1           ; Get float mantissa byte
        srl   tmp1,8                ; MSB to LSB
        a     tmp2,tmp1             ; Add previous result
        ;------------------------------------------------------
        ; Store volume size
        ;------------------------------------------------------   
fm.dir.callback2.volsize.store:
        mov  tmp1,@cat.volsize      ; Store volume size
        ;------------------------------------------------------
        ; Get volume free
        ;------------------------------------------------------ 
fm.dir.callback2.volfree:
        li    tmp0,rambuf + >1b
        movb  *tmp0,tmp1            ; Get Float size byte
        inc   tmp0                  ; Skip float size byte
        movb  *tmp0+,tmp1           ; Get float exponent byte
        srl   tmp1,8                ; MSB to LSB

        movb  *tmp0+,tmp2           ; Get float mantissa byte
        srl   tmp2,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Turn radix 100 floating point into hex number
        ;------------------------------------------------------        
        ai    tmp1,-64              ; Subtract radix 100 exponent bias >40        
        jgt   fm.dir.callback2.volfree.radix100.part1
                                    ; Handle 1st byte if exponent > 1

        mov   tmp2,tmp1             ; No multiplication needed
        jmp   fm.dir.callback2.volfree.store
        ;------------------------------------------------------
        ; Handle mantissa (byte 1) if exp>1
        ;------------------------------------------------------        
fm.dir.callback2.volfree.radix100.part1:
        li    tmp4,100              ; \ Multiply 1st byte mantissa by 100
        mpy   tmp4,tmp2             ; | Result is in 32 bit register tmp2:tmp3
        mov   tmp3,tmp2             ; / Move LSW to MSW
        dec   tmp1                  ; Decrement exponent
        jgt   fm.dir.callback2.volfree.radix100.part1
                                    ; Next iteration if exponent > 0
        ;------------------------------------------------------
        ; Handle mantissa (byte 2) if exp>1, otherwise (byte 1)
        ;------------------------------------------------------   
fm.dir.callback2.volfree.radix100.part2:
        movb  *tmp0+,tmp1           ; Get float mantissa byte
        srl   tmp1,8                ; MSB to LSB
        a     tmp2,tmp1             ; Add previous result
        ;------------------------------------------------------
        ; Store volume free and volume used
        ;------------------------------------------------------   
fm.dir.callback2.volfree.store:
        mov  tmp1,@cat.volfree      ; Store volume free
        mov  @cat.volsize,tmp0      ; \
        s    tmp1,tmp0              ; | Calculate and store volume used
        mov  tmp0,@cat.volused      ; /
        jmp  fm.dir.callback2.exit  ; Exit
        ;------------------------------------------------------
        ; File index handling
        ;------------------------------------------------------ 
fm.dir.callback2.fileindex:        
        mov   @fh.records,tmp0        ; Get counter
        dect  tmp0                    ; Remove volume offset and we're base 0
        sla   tmp0,1                  ; Word align
        mov   @fh.dir.rec.ptr,tmp1    ; Get filename pointer        
        mov   tmp1,@cat.ptrlist(tmp0) ; Save pointer in pointer list
        ;------------------------------------------------------
        ; Prepare for filename copy
        ;------------------------------------------------------
fm.dir.callback2.prep:        
        li    tmp0,rambuf+2         ; Source address
        movb  @rambuf+2,tmp2        ; Get string length 
        srl   tmp2,8                ; MSB to LSB
        jgt   fm.dir.callback2.prep.fncopy        
        ;------------------------------------------------------
        ; Empty filename handling
        ;------------------------------------------------------
        seto  @fh.circbreaker       ; \ Empty filename, set circuit-breaker flag        
                                    ; / This is the last line to process.
        jmp   fm.dir.callback2.filetype                    
        ;------------------------------------------------------
        ; Copy filename to final destination
        ;------------------------------------------------------
fm.dir.callback2.prep.fncopy
        inc   tmp2                  ; Include prefixed length-byte    
        a     tmp2,@fh.dir.rec.ptr  ; Adjust pointer for next filename
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy        
        ;------------------------------------------------------
        ; Filetype handling
        ;------------------------------------------------------        
fm.dir.callback2.filetype:
        movb  @rambuf+2,tmp0        ; Get string length again
        srl   tmp0,8                ; MSB to LSB
        ai    tmp0,rambuf+3         ; Add base, skip record size & length byte
        movb  *tmp0,tmp1            ; Get Float size byte
        inc   tmp0                  ; Skip float size byte
        mov   tmp0,tmp3             ; Take snapshot of position in rambuf        
        swpb  tmp1                  ; Make some space for float exponent byte
        movb  *tmp0+,tmp1           ; Get float exponent byte
        swpb  tmp1                  ; Turn in right order again
        clr   tmp2
        movb  *tmp0+,tmp2           ; Get float 1st Mantissa byte (=Filetype!)

        abs   tmp2                  ; Ignore file write-protection flag        
        li    tmp0,cat.ftlist       ; \ 
        a     @cat.filecount,tmp0   ; | Store file type in filetype list 
        movb  tmp2,*tmp0            ; /

        mov   tmp3,tmp0             ; Restore snapshot position
        srl   tmp1,8                ; Get float size
        a     tmp1,tmp0             ; Skip filetype float        
        ;------------------------------------------------------
        ; File size handling
        ;------------------------------------------------------                
fm.dir.callback2.filesize:        
        movb  *tmp0,tmp1            ; Get Float size byte

        dect  stack
        mov   tmp0,*stack           ; Push tmp0
                                    ; Take snapshot of position in rambuf        

        inc   tmp0                  ; Skip float size byte
        movb  *tmp0+,tmp1           ; Get float exponent byte
        srl   tmp1,8                ; MSB to LSB

        movb  *tmp0+,tmp2           ; Get float mantissa byte
        srl   tmp2,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Turn radix 100 floating point into hex number
        ;------------------------------------------------------        
        ai    tmp1,-64              ; Subtract radix 100 exponent bias >40        
        jgt   fm.dir.callback2.filesize.radix100.part1
                                    ; Handle 1st byte if exponent > 1

        mov   tmp2,tmp1             ; No multiplication needed
        jmp   fm.dir.callback2.filesize.store
        ;------------------------------------------------------
        ; Handle mantissa (byte 1) if exp>1
        ;------------------------------------------------------        
fm.dir.callback2.filesize.radix100.part1:
        li    tmp4,100              ; \ Multiply 1st byte mantissa by 100
        mpy   tmp4,tmp2             ; | Result is in 32 bit register tmp2:tmp3
        mov   tmp3,tmp2             ; / Move LSW to MSW
        dec   tmp1                  ; Decrement exponent
        jgt   fm.dir.callback2.filesize.radix100.part1
                                    ; Next iteration if exponent > 0
        ;------------------------------------------------------
        ; Handle mantissa (byte 2) if exp>1, otherwise (byte 1)
        ;------------------------------------------------------   
fm.dir.callback2.filesize.radix100.part2:
        movb  *tmp0+,tmp1           ; Get float mantissa byte
        srl   tmp1,8                ; MSB to LSB
        a     tmp2,tmp1             ; Add previous result
        ;------------------------------------------------------
        ; Store filesize size in list
        ;------------------------------------------------------   
fm.dir.callback2.filesize.store:
 ;       data  c99_dbg_tmp1          ; \ Print file size in tmp0 
 ;       data  >1001                 ; | in classic99 debugger console.
 ;       data  data.printf.recsize   ; | Needs debug opcodes enabled in 
 ;                                   ; / classic99.ini file. See c99 manual.

        mov   @cat.filecount,tmp0   ; Get file index
        sla   tmp0,1                ; Word align
        ai    tmp0,cat.fslist       ; Add base address
        mov   tmp1,*tmp0            ; Store size (word) in filesize list

        mov   *stack+,tmp0          ; Pop tmp0 
                                    ; Restore snapshot position (float size)

        movb  *tmp0+,tmp1           ; Get Float size byte
        srl   tmp1,8                ; Get float size
        a     tmp1,tmp0             ; Skip filesize float              
        ;------------------------------------------------------
        ; Record size handling in filetype
        ;------------------------------------------------------                
fm.dir.callback2.recsize:        
        movb  *tmp0+,tmp1           ; Get Float size byte
        swpb  tmp1                  ; Make some space for float exponent byte
        movb  *tmp0+,tmp1           ; Get float exponent byte
        srl   tmp1,8                ; MSB to LSB

        movb  *tmp0+,tmp2           ; Get float mantissa byte
        srl   tmp2,8                ; MSB to LSB
        ;------------------------------------------------------
        ; Turn radix 100 floating point into hex number
        ;------------------------------------------------------        
        ai    tmp1,-64              ; Subtract radix 100 exponent bias >40        
        jgt   fm.dir.callback2.recsize.radix100.part1
                                    ; Handle 1st byte if exponent > 1

        mov   tmp2,tmp1             ; No multiplication needed
        jmp   fm.dir.callback2.recsize.store
        ;------------------------------------------------------
        ; Handle mantissa (byte 1) if exp>1
        ;------------------------------------------------------        
fm.dir.callback2.recsize.radix100.part1:
        li    tmp4,100              ; \ Multiply 1st byte mantissa by 100
        mpy   tmp4,tmp2             ; | Result is in 32 bit register tmp2:tmp3
        mov   tmp3,tmp2             ; / Move LSW to MSW
        dec   tmp1                  ; Decrement exponent
        jgt   fm.dir.callback2.recsize.radix100.part1
                                    ; Next iteration if exponent > 0
        ;------------------------------------------------------
        ; Handle mantissa (byte 2) if exp>1, otherwise (byte 1)
        ;------------------------------------------------------   
fm.dir.callback2.recsize.radix100.part2:
        movb  *tmp0+,tmp1           ; Get float mantissa byte
        srl   tmp1,8                ; MSB to LSB
        a     tmp2,tmp1             ; Add previous result
        ;------------------------------------------------------
        ; Store record size in list
        ;------------------------------------------------------   
fm.dir.callback2.recsize.store:
 ;       data  c99_dbg_tmp1          ; \ Print file type record size in tmp0 
 ;       data  >1001                 ; | in classic99 debugger console.
 ;       data  data.printf.recsize   ; | Needs debug opcodes enabled in 
 ;                                   ; / classic99.ini file. See c99 manual.

        li    tmp0,cat.rslist       ; \ 
        a     @cat.filecount,tmp0   ; | Store record size in record size list 
        sla   tmp1,8                ; | LSB to MSB
        movb  tmp1,*tmp0            ; /
        ;------------------------------------------------------
        ; Show filecount
        ;------------------------------------------------------
        bl    @putnum               ; Show filecount
              byte pane.botrow,72   ; \ i p1 = Y,X
              data cat.filecount    ; | i p2 = Number to display
              data rambuf           ; | i p3 = Workbuffer for string conversion
              data >3020            ; / i p4 = ASCII offset, fill character

        inc   @cat.filecount
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback2.exit:
        mov   *stack+,tmp4          ; Pop tmp4
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* fm.dir.callback3
* Callback function "Close file"
***************************************************************
* bl  @fm.dir.callback3
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback3
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.dir.callback3:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off ; \ Put busyline indicator off
                                     ; /

        seto  @cmdb.dirty           ; Command buffer dirty (text changed!)                                     
        ;------------------------------------------------------
        ; Prepare for displaying filenames
        ;------------------------------------------------------
        dec   @cat.filecount        ; \ One-time adjustment because  
                                    ; | catalog reads beyond EOF.
                                    ; /

        ; Depending on the device DSR used (emulators, real HW)
        ; we might or might not get in this callback when there
        ; are no files. So we double check in both the callbacks
        ; fh.callback3 (File close) and fh.callback4 (File I/O error)

        mov   @cat.filecount,tmp0   ; How many files read?
        jgt   fm.dir.callback4.exit ; Have some, so no error please        
        ;-------------------------------------------------------
        ; Show message 'No Device/Disk/Path'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.nodisk       ; No Device/Disk/Path
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay                                    

        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback3.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* fm.dir.callback4
* Callback function "File I/O error"
***************************************************************
* bl  @fm.dir.callback4
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback4
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.dir.callback4:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off
                                    ; Put busyline indicator off

        ; Depending on the device DSR used (emulators, real HW)
        ; we might or might not get in this callback when there
        ; are no files. So we double check in both the callbacks
        ; fh.callback3 (File close) and fh.callback4 (File I/O error)

        mov   @cat.filecount,tmp0   ; How many files read?
        jgt   fm.dir.callback4.exit ; Have some, so no error please        
        ;-------------------------------------------------------
        ; Show message 'No Device/Disk/Path'
        ;-------------------------------------------------------
        bl    @putat
              byte 0,52
              data txt.nodisk       ; No Device/Disk/Path
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay                                    
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback4.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


***************************************************************
* fm.dir.callback5
* Callback function "Memory full"
***************************************************************
* bl  @fm.dir.callback5
*--------------------------------------------------------------
* INPUT
* none
*--------------------------------------------------------------
* OUTPUT
* none
*--------------------------------------------------------------
* Registered as pointer in @fh.callback5
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.dir.callback5:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback5.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

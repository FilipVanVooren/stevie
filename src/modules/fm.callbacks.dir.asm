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
*    0010  SSSSSS1F     
*    0018  FFFFFFF2
*    0020  FFFFFFFF
*    0028  3FFFFFFF
*    0030  F.......
*    0038  ........
*    
*    A=>00 \ Record size 38 bytes (>26) or 146 bytes (>92).
*    B=>26 / Note: only 146 bytes if device supports timestamps.
*    L=>0a String length (max. >0A)
*    S=>xx String ASCII char (filename)
*    
*    1=>08 Float 1 size 
*    F=>xx Float 8 bytes
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
* bl  @fm.dir.callback2
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
        ;------------------------------------------------------
        ; Prepare for reading directory
        ;------------------------------------------------------
        clr   @fh.offsetopcode      ; Allow all devices (copy to VDP)
        clr   @fh.records           ; Reset record count

        li    tmp0,>e000            ; \ Set RAM destination address 
        mov   tmp0,@fh.dir.rec.ptr  ; / for storing directory entries
        ;------------------------------------------------------
        ; Show reading directory message
        ;------------------------------------------------------
        bl    @pane.botline.busy.on ; \ Put busy indicator on
                                    ; /

        bl    @putat
              byte pane.botrow,0
              data txt.readdir      ; Display "Reading directory...."
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback1.exit:
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
* tmp0, tmp1
********|*****|*********************|**************************
fm.dir.callback2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Skip if volume name
        ;------------------------------------------------------
        mov   @fh.records,tmp0      ; \
        ci    tmp0,1                ; | Skip volume name
        jeq   fm.dir.callback2.exit ; / 
        ;------------------------------------------------------
        ; Prepare for copy
        ;------------------------------------------------------
        li    tmp0,rambuf+2         ; Source address
        mov   @fh.dir.rec.ptr,tmp1  ; Destination address

        movb  @rambuf+2,tmp2        ; Get string length 
        srl   tmp2,8                ; MSB to LSB
        inc   tmp2                  ; Include prefixed length-byte    
        a     tmp2,@fh.dir.rec.ptr  ; Adjust pointer for next filename
        ;------------------------------------------------------
        ; Copy filename to final destination
        ;------------------------------------------------------
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy        
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback2.exit:
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
        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /

        ;------------------------------------------------------
        ; Display left column
        ;------------------------------------------------------
        bl    @at                   ; Set cursor position
              byte 1,69             ; Y=1, X=69

        li    tmp1,>e000
        li    tmp2,7
        bl    @putlst               ; Loop over string list and display
                                    ; \ i  @wyx = Cursor position
                                    ; | i  tmp1 = Pointer to first length-
                                    ; |           prefixed string in list
                                    ; / i  tmp2 = Number of strings to display

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
        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
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

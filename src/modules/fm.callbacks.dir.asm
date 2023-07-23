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


*---------------------------------------------------------------
* Callback function "Before open file"
* Open file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback1
*---------------------------------------------------------------
fm.dir.callback1:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
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
        bl    @hchar
              byte pane.botrow,0,32,55
              data EOL              ; Clear hint on bottom row

        dect  stack        
        mov   @parm1,*stack         ; Push @parm1
        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.colorscheme.statlines
                                    ; Set color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        mov   *stack+,@parm1        ; Pop @parm1        

        bl    @putat
              byte pane.botrow,0
              data txt.readdir      ; Display "Reading directory...."
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback1.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Read line from file"
* Read line from file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback2
*---------------------------------------------------------------
fm.dir.callback2:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Prepare for copy
        ;------------------------------------------------------
        li    tmp0,rambuf           ; Source address
        mov   @fh.dir.rec.ptr,tmp1  ; Destination address

        mov   @rambuf,tmp2          ; \ Get record size
        mov   tmp2,@fh.reclen       ; /
        ;------------------------------------------------------
        ; Copy catalog record to final destination
        ;------------------------------------------------------
        bl    @xpym2m               ; Copy memory block
                                    ; \ i  tmp0 = source
                                    ; | i  tmp1 = destination
                                    ; / i  tmp2 = bytes to copy        
        ;------------------------------------------------------
        ; Update stats
        ;------------------------------------------------------
        inc   @fh.records
        a     @fh.reclen,@fh.dir.rec.ptr
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback2.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Close file"
* Close file
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback3
*---------------------------------------------------------------
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
        bl    @hchar
              byte pane.botrow,0,32,72
              data EOL              ; Erase indicator in bottom row

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback3.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "File I/O error"
* File I/O error
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback4
*---------------------------------------------------------------
fm.dir.callback4:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback4.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller


*---------------------------------------------------------------
* Callback function "Memory full"
* Memory full
*---------------------------------------------------------------
* INPUT
* NONE
*---------------------------------------------------------------
* Registered as pointer in @fh.callback5
*---------------------------------------------------------------
fm.dir.callback5:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.dir.callback5.exit:
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

* FILE......: fm_load.asm
* Purpose...: High-level file manager module

*---------------------------------------------------------------
* Load file into editor
*---------------------------------------------------------------
* bl    @fm.loadfile
*--------------------------------------------------------------- 
* INPUT
* tmp0  = Pointer to length-prefixed string containing both 
*         device and filename
********|*****|*********************|**************************
fm.loadfile:
        dect  stack
        mov   r11,*stack            ; Save return address

        mov   tmp0,@parm1           ; Setup file to load
        bl    @edb.init             ; Initialize editor buffer
        bl    @idx.init             ; Initialize index
        bl    @fb.init              ; Initialize framebuffer
        mov   @parm1,@edb.filename.ptr
                                    ; Set filename
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
        bl    @filv
              data sprsat,>0000,4   ; Turn off sprites (cursor)

        mov   @fb.scrrows,tmp1
        mpy   @fb.colsline,tmp1     ; columns per line * rows on screen
                                    ; 16 bit part is in tmp2!

        li    tmp0,80               ; VDP target address (2nd line on screen!)
        li    tmp1,32               ; Character to fill

        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy                                    
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        li    tmp0,fm.loadfile.callback.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadfile.callback.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadfile.callback.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadfile.callback.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        bl    @tfh.file.read.sams   ; Read specified file with SAMS support
                                    ; \ i  parm1 = Pointer to length prefixed file descriptor
                                    ; | i  parm2 = Pointer to callback function "loading indicator 1"
                                    ; | i  parm3 = Pointer to callback function "loading indicator 2"
                                    ; | i  parm4 = Pointer to callback function "loading indicator 3"
                                    ; / i  parm5 = Pointer to callback function "File I/O error handler"

        clr   @edb.dirty            ; Editor buffer fully replaced, no longer dirty
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.loadfile.exit:
        b     @poprt                ; Return to caller



*---------------------------------------------------------------
* Callback function "Show loading indicator 1"
*---------------------------------------------------------------
* Is expected to be passed as parm2 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.callback.indicator1:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Show loading indicators and file descriptor
        ;------------------------------------------------------
        bl    @hchar
              byte 29,3,32,77
              data EOL
        
        bl    @putat
              byte 29,3
              data txt_loading      ; Display "Loading...."

        c     @tfh.rleonload,@w$ffff
        jne   !                                           
        bl    @putat
              byte 29,68
              data txt_rle          ; Display "RLE"

!       bl    @at
              byte 29,14            ; Cursor YX position
        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.callback.indicator1.exit:        
        b     @poprt                ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 2"
*---------------------------------------------------------------
* Is expected to be passed as parm3 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.callback.indicator2:
        dect  stack
        mov   r11,*stack            ; Save return address

        bl    @putnum
              byte 29,75            ; Show lines read
              data edb.lines,rambuf,>3020

        c     @tfh.kilobytes,tmp4
        jeq   fm.loadfile.callback.indicator2.exit

        mov   @tfh.kilobytes,tmp4   ; Save for compare

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data tfh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt_kb           ; Show "kb" string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.callback.indicator2.exit:        
        b     @poprt                ; Return to caller





*---------------------------------------------------------------
* Callback function "Show loading indicator 3"
*---------------------------------------------------------------
* Is expected to be passed as parm4 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.callback.indicator3:
        dect  stack
        mov   r11,*stack            ; Save return address


        bl    @hchar
              byte 29,3,32,50       ; Erase loading indicator
              data EOL

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data tfh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt_kb           ; Show "kb" string

        bl    @putnum
              byte 29,75            ; Show lines read
              data tfh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.callback.indicator3.exit:        
        b     @poprt                ; Return to caller



*---------------------------------------------------------------
* Callback function "File I/O error handler"
*---------------------------------------------------------------
* Is expected to be passed as parm5 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.callback.fioerr:
        dect  stack
        mov   r11,*stack            ; Save return address

        bl    @hchar
              byte 29,0,32,50       ; Erase loading indicator
              data EOL

        bl    @putat
              byte 27,0             ; Display message
              data txt_ioerr

        li    tmp0,txt_newfile
        mov   tmp0,@edb.filename.ptr

        mov   @cmdb.scrrows,@parm1
        bl    @cmdb.show
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.callback.fioerr.exit:        
        b     @poprt                ; Return to caller        
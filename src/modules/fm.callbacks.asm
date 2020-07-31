* FILE......: fm.callbacks.asm
* Purpose...: File Manager - Callbacks for file operations

*---------------------------------------------------------------
* Callback function "Show loading indicator 1"
* Open file
*---------------------------------------------------------------
* Registered as pointer in @fh.callback1
*---------------------------------------------------------------
fm.loadsave.cb.indicator1:
        dect  stack
        mov   r11,*stack            ; Save return address
        ;------------------------------------------------------
        ; Show loading indicators and file descriptor
        ;------------------------------------------------------
        bl    @hchar
              byte 29,0,32,80
              data EOL
        
        bl    @putat
              byte 29,0
              data txt.loading      ; Display "Loading...."

        bl    @at
              byte 29,11            ; Cursor YX position
        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 2"
* Read line from file / Write line to file
*---------------------------------------------------------------
* Registered as pointer in @fh.callback2
*--------------------------------------------------------------- 
fm.loadsave.cb.indicator2:
        ;------------------------------------------------------
        ; Check if updated counters should be displayed
        ;------------------------------------------------------
        c     @fh.kilobytes,@fh.kilobytes.prev
        jeq   !
        ;------------------------------------------------------
        ; Display updated counters
        ;------------------------------------------------------
        dect  stack
        mov   r11,*stack            ; Save return address

        mov   @fh.kilobytes,@fh.kilobytes.prev
                                    ; Save for compare

        bl    @putnum
              byte 29,75            ; Show lines processed
              data edb.lines,rambuf,>3020

        bl    @putnum
              byte 29,56            ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt.kb           ; Show "kb" string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.exit:
        mov   *stack+,r11           ; Pop R11
!       b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 3"
* Close file
*---------------------------------------------------------------
* Registered as pointer in @fh.callback3
*--------------------------------------------------------------- 
fm.loadsave.cb.indicator3:
        dect  stack
        mov   r11,*stack            ; Save return address

        bl    @hchar
              byte 29,3,32,50       ; Erase loading indicator
              data EOL

        bl    @putnum
              byte 29,56            ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte 29,75            ; Show lines processed
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator3.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



*---------------------------------------------------------------
* Callback function "File I/O error handler"
* I/O error
*---------------------------------------------------------------
* Registered as pointer in @fh.callback4
*---------------------------------------------------------------
fm.loadsave.cb.fioerr:
        dect  stack
        mov   r11,*stack            ; Save return address

        bl    @hchar
              byte 29,0,32,50       ; Erase loading indicator
              data EOL        
        ;------------------------------------------------------
        ; Build I/O error message
        ;------------------------------------------------------
        bl    @cpym2m               
              data txt.ioerr+1
              data tv.error.msg+1
              data 34               ; Error message

        mov   @edb.filename.ptr,tmp0
        movb  *tmp0,tmp2            ; Get length byte
        srl   tmp2,8                ; Right align
        inc   tmp0                  ; Skip length byte
        li    tmp1,tv.error.msg+33  ; RAM destination address

        bl    @xpym2m               ; \ Copy CPU memory to CPU memory
                                    ; | i  tmp0 = ROM/RAM source
                                    ; | i  tmp1 = RAM destination
                                    ; / i  tmp2 = Bytes to copy
        ;------------------------------------------------------
        ; Reset filename to "new file"
        ;------------------------------------------------------
        li    tmp0,txt.newfile      ; New file
        mov   tmp0,@edb.filename.ptr

        li    tmp0,txt.filetype.none
        mov   tmp0,@edb.filetype.ptr
                                    ; Empty filetype string
        ;------------------------------------------------------
        ; Display I/O error message
        ;------------------------------------------------------
        bl    @pane.errline.show    ; Show error line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
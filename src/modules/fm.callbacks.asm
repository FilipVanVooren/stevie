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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Check file operation mode
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,80
              data EOL              ; Clear until end of line
        
        mov   @fh.fopmode,tmp0      ; Check file operation mode

        ci    tmp0,fh.fopmode.writefile
        jeq   fm.loadsave.cb.indicator1.saving
                                    ; Saving file?

        ci    tmp0,fh.fopmode.readfile
        jeq   fm.loadsave.cb.indicator1.loading
                                    ; Loading file?
        ;------------------------------------------------------
        ; Display Saving....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.saving:                
        bl    @putat
              byte pane.botrow,0
              data txt.saving       ; Display "Saving...."
        jmp   fm.loadsave.cb.indicator1.filename
        ;------------------------------------------------------
        ; Display Loading....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.loading:        
        bl    @putat
              byte pane.botrow,0
              data txt.loading      ; Display "Loading...."
        ;------------------------------------------------------
        ; Display device/filename
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.filename:        
        bl    @at
              byte pane.botrow,11   ; Cursor YX position
        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename
        ;------------------------------------------------------
        ; Display separators
        ;------------------------------------------------------
        bl    @putat
              byte pane.botrow,71
              data txt.vertline     ; Vertical line
        ;------------------------------------------------------
        ; Display fast mode
        ;------------------------------------------------------
        abs   @fh.offsetopcode
        jeq   fm.loadsave.cb.indicator1.exit

        bl    @putat
              byte pane.botrow,38
              data txt.fastmode     ; Display "FastMode"
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
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
              byte pane.botrow,50   ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte pane.botrow,55
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte pane.botrow,73   ; Show lines processed
              data fh.records,rambuf,>3020
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
              byte pane.botrow,3,32,50       
              data EOL              ; Erase loading indicator

        bl    @putnum
              byte pane.botrow,50   ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte pane.botrow,55
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte pane.botrow,73   ; Show lines processed
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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0     
        ;------------------------------------------------------
        ; Build I/O error message
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,50
              data EOL              ; Erase loading indicator

        mov   @fh.fopmode,tmp0      ; Check file operation mode
        ci    tmp0,fh.fopmode.writefile
        jeq   fm.loadsave.cb.fioerr.mgs2
        ;------------------------------------------------------
        ; Failed loading file
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.mgs1:        
        bl    @cpym2m               
              data txt.ioerr.load+1
              data tv.error.msg+1
              data 34               ; Error message
        jmp   fm.loadsave.cb.fioerr.mgs3
        ;------------------------------------------------------        
        ; Failed saving file
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.mgs2:                
        bl    @cpym2m               
              data txt.ioerr.save+1
              data tv.error.msg+1
              data 34               ; Error message
        ;------------------------------------------------------
        ; Add filename to error message
        ;------------------------------------------------------        
fm.loadsave.cb.fioerr.mgs3:
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
        mov   @fh.fopmode,tmp0      ; Check file operation mode

        ci    tmp0,fh.fopmode.readfile
        jne   !                     ; Only when reading file

        li    tmp0,txt.newfile      ; New file
        mov   tmp0,@edb.filename.ptr

        li    tmp0,txt.filetype.none
        mov   tmp0,@edb.filetype.ptr
                                    ; Empty filetype string
        ;------------------------------------------------------
        ; Display I/O error message
        ;------------------------------------------------------
!       bl    @pane.errline.show    ; Show error line
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.exit:
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
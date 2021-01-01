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
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack        
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Check file operation mode
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,50
              data EOL              ; Clear hint on bottom row

        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; / 

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
        li    tmp0,id.dialog.saveblock
        c     @cmdb.dialog,tmp0     ; Saving code block M1-M2 ?
        jeq   fm.loadsave.cb.indicator1.saveblock
        
        bl    @putat
              byte pane.botrow,0
              data txt.saving       ; Display "Saving...."              
        jmp   fm.loadsave.cb.indicator1.filename
        ;------------------------------------------------------
        ; Display Saving block to DV80 file....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.saveblock:        
        bl    @putat
              byte pane.botrow,0
              data txt.block.save   ; Display "Saving block...."              

        jmp   fm.loadsave.cb.indicator1.separators
        ;------------------------------------------------------
        ; Display Loading....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.loading:        
        bl    @hchar
              byte 0,0,32,50
              data EOL              ; Clear filename

        bl    @putat
              byte pane.botrow,0
              data txt.loading      ; Display "Loading file...."
        ;------------------------------------------------------
        ; Display device/filename
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.filename:        
        bl    @at
              byte pane.botrow,11   ; Cursor YX position
        mov   @edb.filename.ptr,tmp1  
                                    ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename
        ;------------------------------------------------------
        ; Show separators
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.separators:
        bl    @hchar
              byte pane.botrow,50,16,1       ; Vertical line 1
              byte pane.botrow,71,16,1       ; Vertical line 2
              data eol
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
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp1          ; Pop tmp1        
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
        dect  stack
        mov   r11,*stack            ; Push return address
        ;------------------------------------------------------
        ; Check if first page processed (speedup impression)
        ;------------------------------------------------------
        c     @fh.records,@fb.scrrows.max
        jne   fm.loadsave.cb.indicator2.kb
                                    ; Skip framebuffer refresh
        ;------------------------------------------------------
        ; Refresh framebuffer if first page processed
        ;------------------------------------------------------
        clr   @parm1
        bl    @fb.refresh           ; Refresh frame buffer
                                    ; \ i  @parm1 = Line to start with
                                    ; /

        mov   @fb.scrrows.max,@parm1
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /

        ;------------------------------------------------------
        ; Check if updated counters should be displayed
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.kb:
        c     @fh.kilobytes,@fh.kilobytes.prev
        jeq   fm.loadsave.cb.indicator2.exit
        ;------------------------------------------------------
        ; Display updated counters
        ;------------------------------------------------------
        mov   @fh.kilobytes,@fh.kilobytes.prev
                                    ; Save for compare

        bl    @putnum
              byte 0,71             ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 0,76
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte pane.botrow,73   ; Show lines processed
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 3"
* Close file
*---------------------------------------------------------------
* Registered as pointer in @fh.callback3
*--------------------------------------------------------------- 
fm.loadsave.cb.indicator3:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack        
        mov   @parm1,*stack         ; Push @parm1            

        bl    @hchar
              byte pane.botrow,0,32,50       
              data EOL              ; Erase loading indicator

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 

        bl    @putnum
              byte 0,71             ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 0,76
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte pane.botrow,73   ; Show lines processed
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator3.exit:
        mov   *stack+,@parm1        ; Pop @parm1
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
        dect  stack        
        mov   tmp1,*stack           ; Push tmp1
        dect  stack  
        mov   tmp2,*stack           ; Push tmp2
        dect  stack  
        mov   tmp3,*stack           ; Push tmp3
        dect  stack                          
        mov   @parm1,*stack         ; Push @parm1
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

        mov   tmp2,tmp3             ; \
        ai    tmp3,33               ; |  Calculate length byte of error message
        sla   tmp3,8                ; |  and write to string prefix  
        movb  tmp3,@tv.error.msg    ; / 

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

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
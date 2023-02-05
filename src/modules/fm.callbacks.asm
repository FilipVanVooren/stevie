* FILE......: fm.callbacks.asm
* Purpose...: File Manager - Callbacks for file operations

*---------------------------------------------------------------
* Callback function "Show loading indicator 1"
* Open file
*---------------------------------------------------------------
* INPUT
* @parm1 = Pointer to length-prefixed filname descriptor
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
              byte pane.botrow,0,32,55
              data EOL              ; Clear hint on bottom row


        dect  stack        
        mov   @parm1,*stack         ; Push @parm1

        mov   @tv.busycolor,@parm1  ; Get busy color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status line
                                    ; \ i  @parm1 = Color combination
                                    ; / 

        mov   *stack+,@parm1        ; Pop @parm1

        mov   @fh.fopmode,tmp0      ; Check file operation mode
        ci    tmp0,fh.fopmode.writefile
        jeq   fm.loadsave.cb.indicator1.check.saving
                                    ; Saving file?

        ci    tmp0,fh.fopmode.readfile
        jeq   fm.loadsave.cb.indicator1.loading
                                    ; Loading file?
        ;------------------------------------------------------
        ; Check saving mode
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.check.saving:
        li    tmp0,id.file.savefile
        c     @fh.workmode,tmp0     ; Saving all of file
        jeq   fm.loadsave.cb.indicator1.savefile

        li    tmp0,id.file.saveblock
        c     @fh.workmode,tmp0     ; Saving code block M1-M2 ?
        jeq   fm.loadsave.cb.indicator1.saveblock

        li    tmp0,id.file.printfile
        c     @fh.workmode,tmp0     ; Printing all of file
        jeq   fm.loadsave.cb.indicator1.printfile

        li    tmp0,id.file.printblock
        c     @fh.workmode,tmp0     ; Printing code block M1-M2 ?
        jeq   fm.loadsave.cb.indicator1.printblock

        li    tmp0,id.file.clipblock
        c     @fh.workmode,tmp0     ; Saving block to clipboard ?
        jeq   fm.loadsave.cb.indicator1.clipblock

        ;------------------------------------------------------
        ; Unknown save mode. Stop here
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.panic:
        mov   r11,@>ffce            ; \ Save caller address        
        bl    @cpu.crash            ; / Crash and halt system                                    
        ;------------------------------------------------------
        ; Display Saving....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.savefile:
        bl    @putat
              byte pane.botrow,0
              data txt.saving       ; Display "Saving...."
        jmp   fm.loadsave.cb.indicator1.filename
        ;------------------------------------------------------
        ; Display Saving block to file....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.saveblock:        
        bl    @putat
              byte pane.botrow,0
              data txt.block.save   ; Display "Saving block...."

        jmp   fm.loadsave.cb.indicator1.exit
        ;------------------------------------------------------
        ; Display Printing....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.printfile:
        bl    @putat
              byte pane.botrow,0
              data txt.printing    ; Display "Printing...."
        jmp   fm.loadsave.cb.indicator1.exit
        ;------------------------------------------------------
        ; Display Printing block....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.printblock:
        bl    @putat
              byte pane.botrow,0
              data txt.block.print  ; Display "Printing block...."
        jmp   fm.loadsave.cb.indicator1.exit
        ;------------------------------------------------------
        ; Display Copying to clipboard....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.clipblock:
        bl    @putat
              byte pane.botrow,0
              data txt.block.clip  ; Display "Copying to clipboard...."
        jmp   fm.loadsave.cb.indicator1.exit

        ;------------------------------------------------------
        ; Display Loading....
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.loading:        
        bl    @putat
              byte pane.botrow,0
              data txt.loading      ; Display "Loading file...."

        mov   @fh.temp1,tmp0
        ci    tmp0,>ffff
        jne   fm.loadsave.cb.indicator1.filename
                                    ; Skip if inserting file

        bl    @hchar
              byte 0,0,32,50
              data EOL              ; Clear filename
        ;------------------------------------------------------
        ; Display device/filename
        ;------------------------------------------------------
fm.loadsave.cb.indicator1.filename:        
        bl    @at
              byte pane.botrow,11   ; Cursor YX position

        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename  
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
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        ;------------------------------------------------------
        ; Check if first page processed (speedup impression)
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.loadsave:
        c     @fh.records,@fb.scrrows.max
        jne   fm.loadsave.cb.indicator2.kb
                                    ; Skip framebuffer refresh

        mov   @fh.fopmode,tmp0      ; Check file operation mode
        ci    tmp0,fh.fopmode.writefile
        jeq   fm.loadsave.cb.indicator2.topline
                                    ; Saving file

        mov   @fh.temp1,tmp0
        ci    tmp0,>ffff            ; Loading file in clean editor buffer?
        jne   fm.loadsave.cb.indicator2.topline
                                    ; No, inserting file

        clr   @parm1                ; Line to start with, "load" operation
        jmp   fm.loadsave.cb.indicator2.refresh        

fm.loadsave.cb.indicator2.topline:
        mov   @fb.topline,@parm1    ; Line to start with, other operations       
        ;------------------------------------------------------
        ; Refresh framebuffer if 1st page processed, runs once
        ;------------------------------------------------------     
fm.loadsave.cb.indicator2.refresh:
        bl    @fb.refresh           ; Refresh frame buffer
                                    ; \ i  @parm1 = Line to start with
                                    ; /

        mov   @fb.scrrows,@parm1
        bl    @fb.vdpdump           ; Dump frame buffer to VDP SIT                                    
                                    ; \ i  @parm1 = number of lines to dump
                                    ; /
        ;------------------------------------------------------
        ; Display fast mode
        ;------------------------------------------------------
        abs   @fh.offsetopcode
        jeq   fm.loadsave.cb.indicator2.kb

        bl    @hchar
              byte 0,52,32,20       
              data EOL              ; Erase any previous message
              
        bl    @putat
              byte 0,52             ; Position cursor
              data txt.fastmode     ; Display "FastMode"      
        ;------------------------------------------------------
        ; Check if updated counters should be displayed
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.kb:
        c     @fh.kilobytes,@fh.kilobytes.prev
        jeq   fm.loadsave.cb.indicator2.exit
        ;------------------------------------------------------
        ; Only show updated KB if loading/saving/printing file
        ;------------------------------------------------------
        li    tmp0,id.file.savefile
        c     @fh.workmode,tmp0        
        jle   fm.loadsave.cb.indicator2.kb.processed
                                    ; includes id.file.loadfile
                                    ; includes id.file.insertfile
                                    ; includes id.file.appendfile
                                    ; includes id.file.savefile

        li    tmp0,id.file.printfile
        c     @fh.workmode,tmp0        
        jeq   fm.loadsave.cb.indicator2.kb.processed

        li    tmp0,id.file.printblock
        c     @fh.workmode,tmp0        
        jeq   fm.loadsave.cb.indicator2.kb.processed

        jmp   fm.loadsave.cb.indicator2.exit
        ;------------------------------------------------------
        ; Display updated counters
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.kb.processed:
        mov   @fh.kilobytes,@fh.kilobytes.prev
                                    ; Save for compare

        bl    @putnum
              byte 0,71             ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 0,76
              data txt.kb           ; Show "kb" string

fm.loadsave.cb.indicator2.lines:
        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadsave.cb.indicator2.exit:
        mov   *stack+,tmp0          ; Pop tmp0
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
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,72
              data EOL              ; Erase indicator in bottom row

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Only show updated KB if loading/saving full file
        ;------------------------------------------------------
        li    tmp0,id.file.loadfile
        c     @fh.workmode,tmp0    
        jeq   fm.loadsave.cb.message

        li    tmp0,id.file.savefile
        c     @fh.workmode,tmp0        
        jne   fm.loadsave.cb.message

        bl    @putnum
              byte 0,71             ; Show kilobytes processed
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 0,76
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte pane.botrow,72   ; Show lines processed
              data edb.lines,rambuf,>3020
        ;-------------------------------------------------------
        ; Show message 
        ;------------------------------------------------------- 
fm.loadsave.cb.message:
        bl    @hchar
              byte 0,52,32,20       
              data EOL              ; Erase any previous message
              
        bl    @at
              byte 0,52             ; Position cursor
        ;-------------------------------------------------------
        ; Get pointer and display overlay message
        ;------------------------------------------------------- 
        mov   @fh.workmode,tmp0     ; Get work mode
        dec   tmp0                  ; Base 0 offset
        sla   tmp0,1                ; Each entry is a word
        mov   @fm.loadsave.cb.indicator3.data(tmp0),tmp1
                                    ; Get pointer to message

        bl    @xutst0               ; Display string
                                    ; \ i  tmp1 = Pointer to string
                                    ; / i  @wyx = Cursor position at
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
fm.loadsave.cb.indicator3.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
        ;------------------------------------------------------
        ; Table with pointers for messages to display.
        ; (@fh.workmode used as index into table)
        ;------------------------------------------------------
fm.loadsave.cb.indicator3.data:
        data  txt.done.load         ; id.file.loadfile
        data  txt.done.insert       ; id.file.insertfile
        data  txt.done.append       ; id.file.appendfile
        data  txt.done.save         ; id.file.savefile
        data  txt.done.save         ; id.file.saveblock
        data  txt.done.clipboard    ; id.file.clipblock
        data  txt.done.print        ; id.file.printfile
        data  txt.done.print        ; id.file.printblock

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
        mov   tmp4,*stack           ; Push tmp4
        dect  stack                          
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Build I/O error message
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,80
              data EOL              ; Erase loading/saving indicator
        ;------------------------------------------------------
        ; Determine message to display
        ;------------------------------------------------------
        mov   @fh.workmode,tmp0
        ci    tmp0,id.file.printfile
        jeq   fm.loadsave.cb.fioerr.print
        ci    tmp0,id.file.printblock
        jeq   fm.loadsave.cb.fioerr.print

        ci    tmp0,id.file.savefile
        jeq   fm.loadsave.cb.fioerr.save
        ci    tmp0,id.file.saveblock
        jeq   fm.loadsave.cb.fioerr.save
        ci    tmp0,id.file.clipblock
        jeq   fm.loadsave.cb.fioerr.save
        ;------------------------------------------------------
        ; Failed loading file
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.load:
        bl    @cpym2m               
              data txt.ioerr.load
              data tv.error.msg
              data 30               ; Error message

        clr   @edb.special.file     ; Handle as normal file.

        jmp   fm.loadsave.cb.fioerr.addmsg
        ;------------------------------------------------------        
        ; Failed saving file
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.save:                
        bl    @cpym2m               
              data txt.ioerr.save
              data tv.error.msg
              data 30               ; Error message
        jmp   fm.loadsave.cb.fioerr.addmsg
        ;------------------------------------------------------        
        ; Failed saving file
        ;------------------------------------------------------
fm.loadsave.cb.fioerr.print:
        bl    @cpym2m               
              data txt.ioerr.print
              data tv.error.msg
              data 30               ; Error message
        ;------------------------------------------------------
        ; Add filename to error message
        ;------------------------------------------------------        
fm.loadsave.cb.fioerr.addmsg:
        mov   @fh.fname.ptr,tmp0
        movb  *tmp0,tmp2            ; Get length byte filename
        srl   tmp2,8                ; Right align

        movb  @tv.error.msg,tmp3    ; Get length byte error text
        srl   tmp3,8                ; Right align
        mov   tmp3,tmp4

        a     tmp2,tmp3             ; \ 
        sla   tmp3,8                ; | Calculate length of error message                     
        movb  tmp3,@tv.error.msg    ; / and write to length-prefix byte

        inc   tmp0                  ; RAM source address (skip length byte)

        li    tmp1,tv.error.msg     ; \ 
        a     tmp4,tmp1             ; | RAM destination address
        inc   tmp1                  ; /

        bl    @xpym2m               ; \ Copy CPU memory to CPU memory
                                    ; | i  tmp0 = ROM/RAM source
                                    ; | i  tmp1 = RAM destination
                                    ; / i  tmp2 = Bytes to copy        
        ;------------------------------------------------------
        ; Reset filename to "new file" 
        ;------------------------------------------------------
        mov   @fh.workmode,tmp0     ; Get working mode
        ci    tmp0,id.file.loadfile
        jne   !                     ; Only when reading full file

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
fm.loadsave.cb.fioerr.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp4        
        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Memory full" error handler
* Memory full error
*---------------------------------------------------------------
* Registered as pointer in @fh.callback5
*---------------------------------------------------------------
fm.load.cb.memfull:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack                          
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Prepare for error message
        ;------------------------------------------------------
        bl    @hchar
              byte pane.botrow,0,32,55
              data EOL              ; Erase loading indicator
        ;------------------------------------------------------
        ; Failed loading file
        ;------------------------------------------------------
        bl    @cpym2m               
              data txt.memfull.load
              data tv.error.msg
              data 46               ; Error message
        ;------------------------------------------------------
        ; Display memory full error message
        ;------------------------------------------------------
        bl    @pane.errline.show    ; Show error line

        mov   @tv.color,@parm1      ; Set normal color
        bl    @pane.action.colorscheme.statlines
                                    ; Set color combination for status lines
                                    ; \ i  @parm1 = Color combination
                                    ; / 
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.load.cb.memfull.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller        

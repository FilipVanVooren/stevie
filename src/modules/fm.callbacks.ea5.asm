* FILE......: fm.callbacks.ea5.asm
* Purpose...: File Manager - Callbacks for EA5 image file I/O

*---------------------------------------------------------------
* Callback function "Show loading indicator 1"
* Before loading image
*---------------------------------------------------------------
* INPUT
* @parm1 = Pointer to length-prefixed filname descriptor
*---------------------------------------------------------------
* Registered as pointer in @fh.callback1
*---------------------------------------------------------------
fm.load.ea5.cb.indicator1:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack        
        mov   @parm1,*stack         ; Push @parm1
        ;------------------------------------------------------
        ; Display Loading....
        ;------------------------------------------------------
fm.load.ea5.cb.indicator1.loading:        
        bl    @putat
              byte pane.botrow,0
              data txt.loading      ; Display "Loading file...."
        ;------------------------------------------------------
        ; Display device/filename
        ;------------------------------------------------------
fm.load.ea5.cb.indicator1.filename:
        bl    @at
              byte pane.botrow,11   ; Cursor YX position

        mov   @parm1,tmp1           ; Get pointer to file descriptor
        bl    @xutst0               ; Display device/filename  
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.load.ea5.cb.indicator1.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



*---------------------------------------------------------------
* Callback function "Show loading indicator 2"
* After loading image
*---------------------------------------------------------------
* Registered as pointer in @fh.callback2
*--------------------------------------------------------------- 
fm.load.ea5.cb.indicator2:
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
        ; Get next chunk needed flag directly from VRAM
        ;------------------------------------------------------
        bl    @cpyv2m
              data fh.ea5.vdpbuf    ; \ i  p1 = Source VDP address
              data rambuf           ; | i  p2 = Destination RAM address
              data 2                ; / i  p3 = Number of bytes to copy

        mov   @rambuf,tmp0          ; \ Additional chunk needed?
        inc   tmp0                  ; / >FFFF = No more chunks
        jeq   fm.load.ea5.cb.indicator2.exit 
                                    ; No more chunks, exit early
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
        ;-------------------------------------------------------
        ; Show message 
        ;------------------------------------------------------- 
fm.load.ea5.cb.message:
        bl    @hchar
              byte 0,50,32,20       
              data EOL              ; Erase any previous message
              
        bl    @at
              byte 0,52             ; Position cursor
        ;-------------------------------------------------------
        ; Get pointer and display overlay message
        ;------------------------------------------------------- 
        li   tmp1,txt.done.load     ; "Load completed"

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
fm.load.ea5.cb.indicator2.exit:
        mov   *stack+,tmp3          ; Pop tmp3
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1        
        mov   *stack+,tmp0          ; Pop tmp0        
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

*---------------------------------------------------------------
* Callback function "File I/O error handler"
* I/O error
*---------------------------------------------------------------
* Registered as pointer in @fh.callback3
*---------------------------------------------------------------
fm.load.ea5.cb.fioerr:
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
        ci    tmp0,id.file.interrupt
        jeq   fm.load.ea5.cb.fioerr.interrupt
        ;------------------------------------------------------
        ; Failed loading file
        ;------------------------------------------------------
fm.load.ea5.cb.fioerr.load:
        bl    @cpym2m               
              data txt.ioerr.load
              data tv.error.msg
              data 30               ; Error message
        ;------------------------------------------------------
        ; Add filename to error message
        ;------------------------------------------------------        
fm.load.ea5.cb.fioerr.addmsg:
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
        ; Display I/O error message
        ;------------------------------------------------------
fm.load.ea5.cb.fioerr.errmsg:
        bl    @pane.errline.show    ; Show error line
        ;------------------------------------------------------
        ; Restore status line colors
        ;------------------------------------------------------
        bl    @pane.botline.busy.off  ; \ Put busyline indicator off
                                      ; /
        ;-------------------------------------------------------
        ; Setup one shot task for removing overlay message
        ;-------------------------------------------------------          
        li    tmp0,pane.topline.oneshot.clearmsg
        mov   tmp0,@tv.task.oneshot 

        bl    @rsslot               ; \ Reset loop counter slot 3
              data 3                ; / for getting consistent delay
        jmp   fm.load.ea5.cb.fioerr.exit
        ;-------------------------------------------------------
        ; Display I/O interrupted message
        ;-------------------------------------------------------
fm.load.ea5.cb.fioerr.interrupt:
        bl    @cpym2m               
              data txt.ioerr.break
              data tv.error.msg
              data 44               ; Error message
        jmp   fm.load.ea5.cb.fioerr.errmsg
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.load.ea5.cb.fioerr.exit:
        mov   *stack+,@parm1        ; Pop @parm1
        mov   *stack+,tmp3          ; Pop tmp4        
        mov   *stack+,tmp3          ; Pop tmp3        
        mov   *stack+,tmp2          ; Pop tmp2        
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
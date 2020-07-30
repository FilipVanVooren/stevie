* FILE......: fm.load.asm
* Purpose...: File Manager - Load file



***************************************************************
* fm.loadfile
* Load file into editor buffer
***************************************************************
* bl  @fm.loadfile
*--------------------------------------------------------------
* INPUT
* tmp0  = Pointer to length-prefixed string containing both 
*         device and filename
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.loadfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Show dialog "Unsaved changes" if editor buffer dirty
        ;-------------------------------------------------------
        mov   @edb.dirty,tmp1
        jeq   !
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     @dialog.unsaved       ; Show dialog and exit
        ;-------------------------------------------------------
        ; Reset editor
        ;-------------------------------------------------------
!       mov   tmp0,@parm1           ; Setup file to load
        bl    @tv.reset             ; Reset editor
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

 
        bl    @scroff               ; Turn off screen
        
        clr   tmp0                  ; VDP target address (1nd row on screen!)
        li    tmp1,32               ; Character to fill

        bl    @xfilv                ; Fill VDP memory
                                    ; \ i  tmp0 = VDP target address
                                    ; | i  tmp1 = Byte to fill
                                    ; / i  tmp2 = Bytes to copy

        bl    @pane.action.colorscheme.Load
                                    ; Load color scheme and turn on screen
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        li    tmp0,fm.loadfile.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadfile.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadfile.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadfile.cb.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        bl    @fh.file.read.edb     ; Read file into editor buffer
                                    ; \ i  parm1 = Pointer to length prefixed 
                                    ; |            file descriptor
                                    ; | i  parm2 = Pointer to callback
                                    ; |            "loading indicator 1"
                                    ; | i  parm3 = Pointer to callback
                                    ; |            "loading indicator 2"
                                    ; | i  parm4 = Pointer to callback
                                    ; |            "loading indicator 3"
                                    ; | i  parm5 = Pointer to callback 
                                    ; /            "File I/O error handler"

        clr   @edb.dirty            ; Editor buffer content replaced, not
                                    ; longer dirty.

        li    tmp0,txt.filetype.DV80                                     
        mov   tmp0,@edb.filetype.ptr
                                    ; Set filetype display string
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.loadfile.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



*---------------------------------------------------------------
* Callback function "Show loading indicator 1"
* Open file
*---------------------------------------------------------------
* Is expected to be passed as parm2 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.cb.indicator1:
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
fm.loadfile.cb.indicator1.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 2"
*---------------------------------------------------------------
* Read line
* Is expected to be passed as parm3 to @tfh.file.read
* Optimized for performance
*--------------------------------------------------------------- 
fm.loadfile.cb.indicator2:
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
              byte 29,75            ; Show lines read
              data edb.lines,rambuf,>3020

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt.kb           ; Show "kb" string
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.cb.indicator2.exit:
        mov   *stack+,r11           ; Pop R11
!       b     *r11                  ; Return to caller




*---------------------------------------------------------------
* Callback function "Show loading indicator 3"
* Close file
*---------------------------------------------------------------
* Is expected to be passed as parm4 to @tfh.file.read
*--------------------------------------------------------------- 
fm.loadfile.cb.indicator3:
        dect  stack
        mov   r11,*stack            ; Save return address

        bl    @hchar
              byte 29,3,32,50       ; Erase loading indicator
              data EOL

        bl    @putnum
              byte 29,56            ; Show kilobytes read
              data fh.kilobytes,rambuf,>3020

        bl    @putat
              byte 29,61
              data txt.kb           ; Show "kb" string

        bl    @putnum
              byte 29,75            ; Show lines read
              data fh.records,rambuf,>3020
        ;------------------------------------------------------
        ; Exit
        ;------------------------------------------------------
fm.loadfile.cb.indicator3.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller



*---------------------------------------------------------------
* Callback function "File I/O error handler"
*---------------------------------------------------------------
* Is expected to be passed as parm5 to @tfh.file.read
********|*****|*********************|**************************
fm.loadfile.cb.fioerr:
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
                                    ; / i  tmp2 = Bytes top copy
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
fm.loadfile.cb.fioerr.exit:
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller
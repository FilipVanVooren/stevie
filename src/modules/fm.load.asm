* FILE......: fm.load.asm
* Purpose...: File Manager - Load file into editor buffer


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
        ; Show dialog "Unsaved changes" and exit if buffer dirty
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
        li    tmp0,fm.loadsave.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadsave.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadsave.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadsave.cb.fioerr
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
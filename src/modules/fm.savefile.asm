* FILE......: fm.savefile.asm
* Purpose...: File Manager - Save file from editor buffer

***************************************************************
* fm.savefile
* Save file from editor buffer
***************************************************************
* bl  @fm.savefile
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
* parm2  = First line to save (base 0)
* parm3  = Last line to save  (base 0)
* parm4  = Work mode (See id.file.XXXX)
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.savefile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        ;-------------------------------------------------------
        ; Check if filename must be changed in editor buffer
        ;-------------------------------------------------------
        li    tmp0,id.file.savefile ; Saving full file?
        c     @parm4,tmp0 
        jne   !                     ; No, skip changing filename
        ;-------------------------------------------------------
        ; Change filename
        ;-------------------------------------------------------
        mov   @parm1,tmp0           ; Source address
        li    tmp1,edb.filename     ; Target address
        li    tmp2,80               ; Number of bytes to copy
        mov   tmp1,@edb.filename.ptr
                                    ; Set filename

        bl    @xpym2m               ; tmp0 = Memory source address
                                    ; tmp1 = Memory target address
                                    ; tmp2 = Number of bytes to copy

        ;-------------------------------------------------------
        ; Save DV80 file
        ;-------------------------------------------------------
!       mov   @parm2,@parm6         ; First line to save
        mov   @parm3,@parm7         ; Last line to save
        mov   @parm4,@parm8         ; Work mode

        li    tmp0,fm.loadsave.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadsave.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadsave.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadsave.cb.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        bl    @filv
              data sprsat,>0000,16  ; Turn off sprites

        bl    @fh.file.write.edb    ; Save file from editor buffer
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "Before Open file"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "Write line to file"
                                    ; | i  @parm4 = Pointer to callback
                                    ; |             "Close file"
                                    ; | i  @parm5 = Pointer to callback 
                                    ; |             "File I/O error"
                                    ; | i  @parm6 = First line to save (base 0)
                                    ; | i  @parm7 = Last line to save  (base 0)
                                    ; | i  @parm8 = Working mode
                                    ; /

        clr   @edb.dirty            ; Editor buffer no longer dirty.

        li    tmp0,txt.filetype.DV80                                     
        mov   tmp0,@edb.filetype.ptr
                                    ; Set filetype display string
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.savefile.exit:
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller

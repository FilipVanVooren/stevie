* FILE......: fm.insert.asm
* Purpose...: File Manager - Insert file into editor buffer

***************************************************************
* fm.insertfile
* Insert file into editor buffer
***************************************************************
* bl  @fm.insertfile
*--------------------------------------------------------------
* INPUT
* parm1  = Pointer to length-prefixed string containing both 
*          device and filename
* parm2  = Line number to load file at
*--------------------------------------------------------------- 
* OUTPUT
* none
*--------------------------------------------------------------
* Register usage
* tmp0, tmp1
********|*****|*********************|**************************
fm.insertfile:
        dect  stack
        mov   r11,*stack            ; Save return address
        dect  stack
        mov   tmp0,*stack           ; Push tmp0
        dect  stack
        mov   tmp1,*stack           ; Push tmp1
        dect  stack
        mov   tmp2,*stack           ; Push tmp2
        ;-------------------------------------------------------
        ; Clear VDP screen buffer
        ;-------------------------------------------------------
!       bl    @filv
              data sprsat,>0000,16  ; Turn off sprites (cursor)
        ;-------------------------------------------------------
        ; Read DV80 file and display
        ;-------------------------------------------------------
        mov   @parm2,@parm7         ; Get line number

        li    tmp0,fm.loadsave.cb.indicator1
        mov   tmp0,@parm2           ; Register callback 1

        li    tmp0,fm.loadsave.cb.indicator2
        mov   tmp0,@parm3           ; Register callback 2

        li    tmp0,fm.loadsave.cb.indicator3
        mov   tmp0,@parm4           ; Register callback 3

        li    tmp0,fm.loadsave.cb.fioerr
        mov   tmp0,@parm5           ; Register callback 4

        li    tmp0,fm.load.cb.memfull
        mov   tmp0,@parm6           ; Register callback 5

        li    tmp0,id.file.loadblock
        mov   tmp0,@parm8           ; Work mode

        bl    @fh.file.read.edb     ; Read file into editor buffer
                                    ; \ i  @parm1 = Pointer to length prefixed 
                                    ; |             file descriptor
                                    ; | i  @parm2 = Pointer to callback
                                    ; |             "Before Open file"
                                    ; | i  @parm3 = Pointer to callback
                                    ; |             "Read line from file"
                                    ; | i  @parm4 = Pointer to callback
                                    ; |             "Close file"
                                    ; | i  @parm5 = Pointer to callback 
                                    ; |             "File I/O error"
                                    ; | i  @parm6 = Pointer to callback
                                    ; |             "Memory full error"
                                    ; | i  @parm7 = Line to insert file at
                                    ; |             or >ffff for new file 
                                    ; / i  @parm8 = Work mode                                                                          
*--------------------------------------------------------------
* Exit
*--------------------------------------------------------------
fm.insertfile.exit:
        mov   *stack+,tmp2          ; Pop tmp2
        mov   *stack+,tmp1          ; Pop tmp1
        mov   *stack+,tmp0          ; Pop tmp0      
        mov   *stack+,r11           ; Pop R11
        b     *r11                  ; Return to caller